import sys
import itertools
import fnmatch
import re

from typing import Optional
from abc import ABC, abstractmethod

from prompt_toolkit import prompt

from redasql.api_client import ApiClient
from redasql.constants import SQL_KEYWORDS, SQL_KEYWORDS_META_DICT, OperatorType, FormatterType
from redasql.dto import MetaCommandReturnList, NewAttribute, DataSourceResponse
from redasql.exceptions import InvalidMetaCommand, InvalidSettingError, InsufficientParametersError
from redasql.result_formatter import Formatter, formatter_factory


class MetaCommandBase(ABC):
    def __init__(self, client: ApiClient, data_source: DataSourceResponse, pivoted: bool, formatter: Formatter):
        self.client = client
        self.data_source = data_source
        self.pivoted = pivoted
        self.formatter = formatter

    @staticmethod
    @abstractmethod
    def help_text():
        raise NotImplemented()

    @abstractmethod
    def exec(self, *args, **kwargs) -> Optional[MetaCommandReturnList]:
        pass


class HelpCommandExecutor(MetaCommandBase):

    @staticmethod
    def help_text():
        return 'HELP META COMMANDS.'

    def exec(self, *args, **kwargs):
        for command, executor in EXECUTORS.items():
            print(f'{command}: {executor.help_text()}')


class DescribeCommandExecutor(MetaCommandBase):

    @staticmethod
    def help_text():
        return 'DESCRIBE TABLE'

    def exec(self, schema_name: str = None, *args, **kwargs) -> Optional[MetaCommandReturnList]:
        schemas = self.client.get_schema(self.data_source.id)
        # show all tables
        if not schema_name:
            print(f'## schemas in {self.data_source.name}')
            for schema in schemas:
                print(f'- {schema.name}')
            return

        for schema in schemas:
            if self._is_match(schema_name, schema.name):
                print(f'## {schema.name}')
                for col in schema.columns:
                    print(f'- {col}')
        return

    @staticmethod
    def _is_match(search_schema_name, target_schema_name):
        """
        support wildcard(*)
        """
        return fnmatch.fnmatch(target_schema_name.lower(), search_schema_name.lower())


class ConnectCommandExecutor(MetaCommandBase):

    @staticmethod
    def help_text():
        return 'SELECT DATASOURCE.'

    def exec(self, data_source_name: str = None, *args, **kwargs) -> Optional[MetaCommandReturnList]:
        if not data_source_name:
            data_sources = self.client.get_data_sources()
            for ds in data_sources:
                print(f'{ds.name}:{ds.type}')
            complete_sources = NewAttribute(
                attr_name='complete_sources',
                value=[d.name for d in data_sources],
                operator=OperatorType.APPEND,
            )
            complete_meta_dict = NewAttribute(
                attr_name='complete_meta_dict',
                value={d.name: 'datasource' for d in data_sources},
                operator=OperatorType.APPEND,
            )

            return MetaCommandReturnList(
                new_attrs=[complete_sources, complete_meta_dict]
            )
        data_source = self.client.get_data_source_by_name(data_source_name)
        schemas = self.client.get_schema(data_source_id=data_source.id)
        new_data_source = NewAttribute(
            value=data_source,
            attr_name='data_source'
        )
        schema_names = [schema.name for schema in schemas]
        column_names = list(
            itertools.chain.from_iterable([schema.columns for schema in schemas])
        )
        meta_dict = {s: 'table' for s in schema_names}
        meta_dict.update(
            {c: 'column' for c in column_names}
        )
        meta_dict.update(SQL_KEYWORDS_META_DICT)
        new_complete_sources = NewAttribute(
            attr_name='complete_sources',
            value=schema_names + column_names + SQL_KEYWORDS,
        )
        new_complete_meta_dict = NewAttribute(
            attr_name='complete_meta_dict',
            value=meta_dict,
        )
        return MetaCommandReturnList(
            new_attrs=[
                new_data_source,
                new_complete_sources,
                new_complete_meta_dict,
            ]
        )


class ChangePivotCommandExecutor(MetaCommandBase):

    @staticmethod
    def help_text():
        return 'QUERY RESULT TOGGLE PIVOT.'

    def exec(self, *args, **kwargs) -> MetaCommandReturnList:
        new_pivoted = not self.pivoted
        print(f'set pivoted [{new_pivoted}]')
        return MetaCommandReturnList(
            new_attrs=[NewAttribute(
                value=not self.pivoted,
                attr_name='pivoted'
            )]
        )


class FormatterChangeExecutor(MetaCommandBase):

    @staticmethod
    def help_text():
        return f'CHANGE RESULT FORMATTER {FormatterType.values()}.'

    def exec(self, formatter_type_name: str = None, *args, **kwargs) -> Optional[MetaCommandReturnList]:
        if not formatter_type_name:
            print(f'current formatter is [{self.formatter.formatter_type.value}]')
            return

        if not FormatterType.is_valid_formatter_type_name(formatter_type_name):
            raise InvalidSettingError(
                f'{formatter_type_name} is not valid formatter type.(chose in {FormatterType.values()})'
            )
        new_formatter_type = FormatterType(formatter_type_name)

        print(f'set formatter [{new_formatter_type.value}]')
        return MetaCommandReturnList(
            new_attrs=[NewAttribute(
                value=formatter_factory(new_formatter_type),
                attr_name='formatter'
            )]
        )

class LoadQueryExecutor(MetaCommandBase):

    @staticmethod
    def help_text():
        return 'LOAD QUERY FROM REDASH.'

    def exec(self, query_id: str = None, *args, **kwargs):
        if not query_id:
            raise InsufficientParametersError('query_id is not specifed.')
        if not query_id.isdigit():
            raise InvalidSettingError(f'[{query_id}] is invalid query_id.')
        query_response = self.client.get_query_by_id(int(query_id))
        query = query_response.query
        for parameter in query_response.parameters:
            answer = prompt(f'{parameter.name}? > ')
            query = self._resplace_parameter(query, parameter.name, answer)
        print(query)
        # set buffer for query execution and add history
        new_attrs = [
            NewAttribute(
                value=[query],
                attr_name='input_buffer',
                operator=OperatorType.REPLACE,
            ),
            NewAttribute(
                value=query,
                attr_name='history',
                method_name='append_string',
                operator=OperatorType.CALL,
            ),
        ]
        # change datasource for query execution.
        if query_response.data_source_id != self.data_source.id:
            data_source = self.client.get_data_source_by_id(query_response.data_source_id)
            print(f'[warn] datasource change to [{data_source.name}]')
            new_attrs.append(
                NewAttribute(
                    value=data_source,
                    attr_name='data_source',
                    operator=OperatorType.REPLACE,
                )
            )

        return MetaCommandReturnList(
            new_attrs=new_attrs
        )

    @staticmethod
    def _resplace_parameter(base_str: str, replace_keyword, replace_value):
        return re.sub(f'{{{{ *{replace_keyword} *}}}}', replace_value, base_str)


class QuitCommandExecutor(MetaCommandBase):

    @staticmethod
    def help_text():
        return 'EXIT.'

    def exec(self, *args, **kwargs):
        print('Sayonara!')
        sys.exit(0)


def meta_command_factory(command: str):

    executor = EXECUTORS.get(command)
    if not executor:
        raise InvalidMetaCommand(f'{command} is not a valid meta command.')

    return executor


EXECUTORS = {
    r'\?': HelpCommandExecutor,
    r'\q': QuitCommandExecutor,
    r'\d': DescribeCommandExecutor,
    r'\c': ConnectCommandExecutor,
    r'\x': ChangePivotCommandExecutor,
    r'\f': FormatterChangeExecutor,
    r'\l': LoadQueryExecutor,
}
