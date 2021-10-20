import os
import re
import readline
import sys
from textwrap import dedent
from redasql.api_client import ApiClient
from redasql.exceptions import RedasqlException
from redasql.metacommand_executor import ConnectCommandExecutor, DescribeCommandExecutor, ChangeFormatterCommandExecutor
from redasql.result_formatter import table_formatter, pivoted_formatter


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
        self.pivoted = False
        # TODO かたていぎ
        self.data_source = None
        self.buffer = []

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
        while True:
            try:
                self.main()
            except RedasqlException as e:
                print(e)
            except KeyboardInterrupt:
                # ctrl + c では終了させない
                # TODO: SQL> SQL> SQL> ってなるのを直したい
                self.buffer = []
            except EOFError:
                # ctrl + d で終了させる
                print('Sayonara!')
                sys.exit(0)

    def main(self):
        answer = input(self._get_prompt())

        # metacommand かのチェックが必要 \dとか
        if answer.strip().startswith('\\'):
            command, *args = re.split(r'\s+', answer.strip())
            executors = {
                r'\d': DescribeCommandExecutor,
                r'\c': ConnectCommandExecutor,
                r'\x': ChangeFormatterCommandExecutor,
            }
            executor = executors.get(command)
            if not executor:
                return
            e = executor(self.client, self.data_source, self.pivoted)
            results = e.exec(*args)
            for result in results:
                setattr(self, result.attr_name, result.value)

            return

        self.buffer.append(answer)
        if answer.strip().endswith(';'):
            query = '\n'.join(self.buffer)
            self.buffer = []
            result = self.execute_query(
                query=query,
                data_source_id=self.data_source['id']
            )
            formatted_string = self._get_formatter()(result)
            print(formatted_string)

    def _get_prompt(self):
        if self.data_source:
            return f'{self.data_source["name"]}=# '
        return '(No DataSource)=# '

    def _get_formatter(self):
        if self.pivoted:
            return pivoted_formatter
        return table_formatter

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
    command.loop()


if __name__ == '__main__':
    main()
