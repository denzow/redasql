import argparse
import os
import re
import readline
import sys
from textwrap import dedent
from os.path import expanduser
from typing import Optional

from prompt_toolkit.history import FileHistory

import redasql.utils as utils
from redasql.api_client import ApiClient
from redasql.dto import DataSourceDTO
from redasql.exceptions import RedasqlException
from redasql.metacommand_executor import ConnectCommandExecutor, DescribeCommandExecutor, ChangeFormatterCommandExecutor
from redasql.result_formatter import table_formatter, pivoted_formatter
from prompt_toolkit import prompt


class MainCommand:

    def __init__(
        self,
        endpoint: str,
        api_key: str,
        data_source_name: Optional[str],
    ):
        self.endpoint = endpoint
        self.api_key = api_key
        self.client = ApiClient(
            redash_url=self.endpoint,
            api_key=self.api_key
        )
        self.pivoted = False
        self.data_source: Optional[DataSourceDTO] = None
        if data_source_name:
            executor = ConnectCommandExecutor(self.client, None, False)
            meta_command_return_list = executor.exec(data_source_name=data_source_name)
            if meta_command_return_list:
                meta_command_return_list.apply(self)

        self.input_buffer = []

        self.history = FileHistory(f'{expanduser("~")}/.redasql.hist')

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
                print('Cancel')
                self.input_buffer = []
            except EOFError:
                print('Sayonara!')
                sys.exit(0)

    def main(self):
        answer = prompt(self._get_prompt(), history=self.history)

        # ignore empty line. if no buffer.
        if not self.input_buffer and utils.is_empty(answer):
            return
        self.input_buffer.append(answer)

        if utils.is_meta_command(answer):
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
            meta_command_return_list = e.exec(*args)
            if meta_command_return_list:
                meta_command_return_list.apply(self)
            return

        if utils.is_sql_end(answer):
            query = '\n'.join(self.input_buffer)
            self.input_buffer = []
            result = self.execute_query(
                query=query,
                data_source_id=self.data_source.id
            )
            formatted_string = self._get_formatter()(result)
            print(formatted_string)

    def _get_prompt(self):
        data_source_name = '(No DataSource)'
        if self.data_source:
            data_source_name = f'{self.data_source.name}'
        suffix = '-' if self.input_buffer else '='
        return f'{data_source_name}{suffix}# '

    def _get_formatter(self):
        if self.pivoted:
            return pivoted_formatter
        return table_formatter


def main(data_source: str):
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
        data_source_name=data_source,
    )
    print(f'server version: {command.get_version()}')
    command.loop()


def init():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--data-source', default=None)
    args = parser.parse_args()
    return args.data_source


if __name__ == '__main__':
    data_source = init()
    main(data_source=data_source)
