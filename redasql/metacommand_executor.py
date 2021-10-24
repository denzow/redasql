import sys
import itertools
from typing import Optional
from abc import ABC, abstractmethod

from redasql.api_client import ApiClient
from redasql.constants import SQL_KEYWORDS, SQL_KEYWORDS_META_DICT
from redasql.dto import MetaCommandReturnList, NewAttribute, OperatorType, DataSourceResponse
from redasql.exceptions import InvalidMetaCommand


class MetaCommandBase(ABC):
    def __init__(self, client: ApiClient, data_source: DataSourceResponse, pivoted: bool):
        self.client = client
        self.data_source = data_source
        self.pivoted = pivoted

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
            if schema.name.lower() == schema_name.lower():
                print(f'## {schema.name}')
                for col in schema.columns:
                    print(f'- {col}')
                break
        return


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


class ChangeFormatterCommandExecutor(MetaCommandBase):

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
    r'\d': DescribeCommandExecutor,
    r'\c': ConnectCommandExecutor,
    r'\x': ChangeFormatterCommandExecutor,
    r'\q': QuitCommandExecutor,
}
