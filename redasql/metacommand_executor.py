from typing import List, Optional
from abc import ABC, abstractmethod

from redasql.api_client import ApiClient
from redasql.dto import MetaCommandReturnList, NewAttribute
from redasql.exceptions import InvalidMetaCommand


class MetaCommandBase(ABC):
    def __init__(self, client: ApiClient, data_source, pivoted: bool):
        self.client = client
        self.data_source = data_source
        self.pivoted = pivoted

    @abstractmethod
    def exec(*args, **kwargs) -> Optional[MetaCommandReturnList]:
        pass


class DescribeCommandExecutor(MetaCommandBase):

    def exec(self, schema_name, *args, **kwargs) -> Optional[MetaCommandReturnList]:
        result = self.client.get_schemas(self.data_source['id'])
        for schema in result['schema']:
            if schema['name'].lower() == schema_name.lower():
                for col in schema['columns']:
                    print(col)
                break
        return


class ConnectCommandExecutor(MetaCommandBase):

    def exec(self, data_source_name: str = None, *args, **kwargs) -> Optional[MetaCommandReturnList]:
        if not data_source_name:
            for ds in self.client.get_data_sources():
                print(f'{ds.name}:{ds.type}')
            return
        data_source = self.client.get_data_source_by_name(data_source_name)
        return MetaCommandReturnList(
            new_attrs=[NewAttribute(
                value=data_source,
                attr_name='data_source'
            )]
        )


class ChangeFormatterCommandExecutor(MetaCommandBase):
    def exec(self, *args, **kwargs) -> MetaCommandReturnList:
        new_pivoted = not self.pivoted
        print(f'set pivoted [{new_pivoted}]')
        return MetaCommandReturnList(
            new_attrs=[NewAttribute(
                value=not self.pivoted,
                attr_name='pivoted'
            )]
        )


def meta_command_factory(command: str):
    executors = {
        r'\d': DescribeCommandExecutor,
        r'\c': ConnectCommandExecutor,
        r'\x': ChangeFormatterCommandExecutor,
    }
    executor = executors.get(command)
    if not executor:
        raise InvalidMetaCommand(f'{command} is not a valid meta command.')

    return executor
