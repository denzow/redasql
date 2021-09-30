from redasql.api_client import ApiClient


class DescribeCommandExecutor:

    def __init__(self, client: ApiClient):
        self.client = client
