import os
from textwrap import dedent
from redasql.api_client import ApiClient


class MainCommand:

    def __init__(
        self,
        endpoint: str,
        api_key: str,
    ):
        self.endpoint = endpoint
        self.api_key = api_key
        self.client = ApiClient(
            redash_url=self.endpoint,
            api_key=self.api_key
        )

    def get_version(self):
        return self.client.get_version()

    def get_queries(self):
        return self.client.get_queries()

    def execute_query(self):
        return self.client.execute_query(query='SELECT * FROM country;', data_source_id=1)


if __name__ == '__main__':
    print(dedent("""
    ____          _                 _ 
    |  _ \ ___  __| | __ _ ___  __ _| |
    | |_) / _ \/ _` |/ _` / __|/ _` | |
    |  _ <  __/ (_| | (_| \__ \ (_| | |
    |_| \_\___|\__,_|\__,_|___/\__, |_|
                                  |_|  
    """))
    command = MainCommand(
        endpoint=os.environ['REDASH_ENDPOINT_URL'],
        api_key=os.environ['REDASH_APIKEY'],
    )
    print(f'server version: {command.get_version()}')
    # print(command.execute_query())
