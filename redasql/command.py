import os
import readline
from textwrap import dedent
from redasql.api_client import ApiClient
from redasql.metacommand_executor import DescribeCommandExecutor
from redasql.result_formatter import table_formatter


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
        # TODO データソースID固定
        self.datasource_id = 1
        self.buffer = []
        self.formatter = table_formatter

    def get_version(self):
        return self.client.get_version()

    def get_queries(self):
        return self.client.get_queries()

    def execute_query(self, query: str, data_source_id: int):
        return self.client.execute_query(
            query=query,
            data_source_id=data_source_id,
        )

    def loop(self):
        answer = input('SQL> ')

        # TODO
        # metacommand かのチェックが必要 \dとか
        if answer.strip().startswith('\\'):
            import re
            command, *args = re.split(r'\s+', answer.strip())

            executors = {r'\d': DescribeCommandExecutor}
            executor = executors.get(command)
            if not executor:
                return
            e = executor(self.client, self.datasource_id)
            e.exec(*args)

            return

        self.buffer.append(answer)
        if answer.strip().endswith(';'):
            query = '\n'.join(self.buffer)
            self.buffer = []
            result = self.execute_query(
                query=query,
                data_source_id=self.datasource_id
            )
            formatted_string = self.formatter(result)
            print(formatted_string)


def main():
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
    while True:
        command.loop()


if __name__ == '__main__':
    main()
