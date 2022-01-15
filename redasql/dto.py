import datetime
import dataclasses
from typing import Optional, Any, List

from redasql.constants import OperatorType


@dataclasses.dataclass(frozen=True)
class CommandArgs:
    api_key: Optional[str]
    endpoint: Optional[str]
    data_source_name: Optional[str]
    proxy: Optional[str]
    ignore_rc: bool
    debug: bool

    def to_dict(self):
        return dataclasses.asdict(self)


@dataclasses.dataclass(frozen=True)
class DataSourceResponse:
    """
    response for datasources api
    {
        'name': 'metadata',
        'pause_reason': None,
        'syntax': 'sql',
        'paused': 0,
        'view_only': False,
        'type': 'pg',
        'id': 2
    }
    """
    id: int
    name: str
    syntax: str
    paused: int
    view_only: bool
    type: str
    pause_reason: Optional[str]
    supports_auto_limit: Optional[bool] = None  # over v9 attributes

    @classmethod
    def from_response(cls, response: dict):
        return cls(**response)


@dataclasses.dataclass(frozen=True)
class QueryResultColumn:
    friendly_name: str
    type: str
    name: str


@dataclasses.dataclass(frozen=True)
class QueryResultData:
    rows: List[dict]
    columns: List[QueryResultColumn]

    @classmethod
    def from_response(cls, data_response):
        return cls(
            rows=data_response['rows'],
            columns=[
                QueryResultColumn(**c)
                for c in data_response['columns']
            ]
        )


@dataclasses.dataclass(frozen=True)
class QueryResultResponse:
    """
    response for query_result api
    {
        'retrieved_at': '2021-10-22T16:25:33.186Z',
        'query_hash': 'd7d1d45bcb946547b382bb0e7853c185',
        'query': 'select 1;',
        'runtime': 0.00282192230224609,
        'data': {
            'rows': [
                {'1': 1}
            ],
            'columns': [
                {'friendly_name': '1', 'type': 'integer', 'name': '1'}
            ]
        },
        'id': 33,
        'data_source_id': 1
    }
    """
    id: int
    data_source_id: int
    retrieved_at: datetime
    query_hash: str
    query: str
    runtime: float
    data: QueryResultData

    @property
    def rows_count(self):
        return len(self.data.rows)

    @property
    def rows_count_for_display(self):
        if self.rows_count > 1:
            return f'{self.rows_count} rows returned.'
        return f'{self.rows_count} row returned.'

    @property
    def runtime_for_display(self):
        return f'Time: {round(self.runtime, 4)}s'

    @classmethod
    def from_response(cls, response):
        return cls(
            id=response['id'],
            data_source_id=response['data_source_id'],
            retrieved_at=datetime.datetime.fromisoformat(
                response['retrieved_at'].replace('Z', '+00:00')
            ),
            query_hash=response['query_hash'],
            query=response['query'],
            runtime=response['runtime'],
            data=QueryResultData.from_response(response['data']),
        )


@dataclasses.dataclass(frozen=True)
class SchemaResponse:
    """
    response for query_result api
    {
        'schema': [
            {
                'name': 'city',
                'columns': ['ID', 'Name', 'CountryCode', 'District', 'Population']
            },
        ]
    }
    """
    name: str
    columns: List[str]

    @classmethod
    def from_response(cls, response):
        return cls(
            name=response['name'],
            columns=response['columns'],
        )


@dataclasses.dataclass(frozen=True)
class QueryParameterResponse:
    name: str
    title: str
    global_: bool
    value: Any
    type: str
    parent_query_id: int

    @classmethod
    def from_response(cls, response: dict):
        return cls(
            name=response['name'],
            title=response['title'],
            global_=response['global'],
            value=response['value'],
            type=response['type'],
            parent_query_id=response['parentQueryId']
        )



@dataclasses.dataclass(frozen=True)
class QueryResponse:
    query: str
    data_source_id: int
    parameters: List[QueryParameterResponse]

    @classmethod
    def from_response(cls, response):
        return cls(
            query=response['query'],
            data_source_id=response['data_source_id'],
            parameters=[
                QueryParameterResponse.from_response(p)
                for p in response['options']['parameters']
            ],
        )


@dataclasses.dataclass(frozen=True)
class NewAttribute:
    attr_name: str
    value: Any
    method_name: Optional[str] = None
    operator: OperatorType = OperatorType.REPLACE


@dataclasses.dataclass(frozen=True)
class MetaCommandReturnList:
    """
    return object for meta command
    """
    new_attrs: List[NewAttribute]

    def apply(self, target: Any):
        for attribute in self.new_attrs:
            if attribute.operator is OperatorType.REPLACE:
                # handle 'hoge.foo' attr name
                attrs = list(reversed(attribute.attr_name.split('.')))
                new_target = target
                while len(attrs) > 1:
                    attr = attrs.pop()
                    new_target = getattr(new_target, attr)
                setattr(new_target, attrs[0], attribute.value)

            elif attribute.operator is OperatorType.CALL:
                attrs = attribute.attr_name.split('.')
                new_target = target
                while len(attrs) > 1:
                    attr = attrs.pop()
                    new_target = getattr(new_target, attr)
                getattr(new_target, attribute.method_name)(attribute.value)
            else:
                print(f'{attribute.operator} is unknown.')
