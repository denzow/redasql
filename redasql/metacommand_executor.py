import dataclasses
from typing import List
from abc import ABC, abstractmethod
from dataclasses import dataclass

from redasql.api_client import ApiClient


@dataclasses.dataclass
class MetaCommandReturn:
    attr_name: str
    value: object


class MetaCommandBase(ABC):
    def __init__(self, client: ApiClient, data_source, pivoted: bool):
        self.client = client
        self.data_source = data_source
        self.pivoted = pivoted

    @abstractmethod
    def exec(*args, **kwargs) -> List[MetaCommandReturn]:
        pass




class DescribeCommandExecutor(MetaCommandBase):

    def exec(self, schema_name, *args, **kwargs):
        result = self.client.get_schemas(self.data_source['id'])
        for schema in result['schema']:
            if schema['name'].lower() == schema_name.lower():
                for col in schema['columns']:
                    print(col)
                break
        return []


class ConnectCommandExecutor(MetaCommandBase):

    def exec(self, data_source_name: str=None, *args, **kwargs):
        if not data_source_name:
            for ds in self.client.get_data_sources():
                print(ds['name'])
            return []
        data_source = self.client.get_data_source_by_name(data_source_name)
        return [MetaCommandReturn(
          value=data_source,
          attr_name='data_source'
        )]

class ChangeFormatterCommandExecutor(MetaCommandBase):
    def exec(self, *args, **kwargs) -> List[MetaCommandReturn]:
        return [MetaCommandReturn(
            value=not self.pivoted,
            attr_name='pivoted'
        )]
