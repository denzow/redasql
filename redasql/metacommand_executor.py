from redasql.api_client import ApiClient


class DescribeCommandExecutor:

    def __init__(self, client: ApiClient, datasource_id: int):
        self.client = client
        self.datasource_id = datasource_id

    def exec(self, schema_name, *args, **kwargs):
        result = self.client.get_schemas(self.datasource_id)
        for schema in result['schema']:
            if schema['name'].lower() == schema_name.lower():
                for col in schema['columns']:
                    print(col)
                break
