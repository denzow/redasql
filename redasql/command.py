import argparse
import os
import itertools
import re
import sys
import pkg_resources
from pyperclip import copy

from textwrap import dedent
from os.path import expanduser, exists
from typing import Optional, List

from prompt_toolkit import prompt
from prompt_toolkit.history import FileHistory

import redasql.utils as utils
from redasql.api_client import ApiClient
from redasql.constants import FormatterType, CompleterType, SQL_KEYWORDS, OutputType
from redasql.dto import CommandArgs, DataSourceResponse, SchemaResponse
from redasql.exceptions import RedasqlException, InsufficientParametersError, NoDataSourceError
from redasql.metacommand_executor import meta_command_factory
from redasql.result_formatter import formatter_factory
from redasql.completer import RedasqlCompleter


VERSION = pkg_resources.get_distribution('redasql').version


class CompleteData:
    def __init__(self):
        self.keywords = SQL_KEYWORDS
        self.schemas: List[SchemaResponse] = []
        self.data_sources = []
        self.formats = FormatterType.values()
        self.outputs = OutputType.values()

    @property
    def column_names(self):
        return list(
            itertools.chain.from_iterable([schema.columns for schema in self.schemas])
        )

    @property
    def schema_names(self):
        return [schema.name for schema in self.schemas]

    def get_completer_words(self):
        words = list(set(
                self.column_names +
                self.schema_names +
                self.keywords +
                self.data_sources +
                self.formats +
                self.outputs
        ))
        return sorted(words, key=lambda x: len(x))

    def get_completer_meta_dict(self):
        meta_dict = {}
        meta_dict.update({c: CompleterType.TABLE.value for c in self.schema_names})
        meta_dict.update({c: CompleterType.COLUMN.value for c in self.column_names})
        meta_dict.update({c: CompleterType.KEYWORD.value for c in self.keywords})
        meta_dict.update({c: CompleterType.DATA_SOURCE.value for c in self.data_sources})
        meta_dict.update({c: CompleterType.FORMAT.value for c in self.formats})
        meta_dict.update({c: CompleterType.OUTPUT.value for c in self.outputs})
        return meta_dict


class MainCommand:

    def __init__(
        self,
        endpoint: str,
        api_key: str,
        proxy: str,
        data_source_name: Optional[str],
        ignore_rc: bool,
        debug: bool,
    ):
        self.endpoint = endpoint if endpoint else os.environ.get('REDASQL_REDASH_ENDPOINT')
        self.api_key = api_key if api_key else os.environ.get('REDASQL_REDASH_APIKEY')
        if self.endpoint is None or self.api_key is None:
            raise InsufficientParametersError(dedent("""
            "endpoint" and "api key" are absolutely necessary. use args or environment
            """))

        self.proxy = proxy if proxy else os.environ.get('REDASQL_HTTP_PROXY')
        self.ignore_rc = ignore_rc
        self.debug = debug
        self.client = ApiClient(
            redash_url=self.endpoint,
            api_key=self.api_key,
            proxy=self.proxy,
            debug=debug,
        )
        self.pivoted = False
        self.output = OutputType.STDOUT
        self.formatter = formatter_factory(FormatterType.TABLE)
        self.input_buffer = []
        self.complete_data = CompleteData()
        self.history = FileHistory(f'{expanduser("~")}/.redasql.hist')
        self.data_source: Optional[DataSourceResponse] = None

        data_source_list = self.client.get_data_sources()
        self.complete_data.data_sources = [d.name for d in data_source_list]
        if data_source_name:
            self.execute_meta_command_handler(fr'\c {data_source_name}')

    def load_config_from_rc_file(self):
        if self.ignore_rc:
            return
        rc_file_path = os.environ.get('REDASQL_RCFILE') if os.environ.get('REDASQL_RCFILE') \
            else f'{expanduser("~")}/.redasqlrc'
        if not exists(rc_file_path):
            return
        with open(rc_file_path, 'r') as f:
            print(f'** load rc file from {rc_file_path} **')
            for line in f:
                if line:
                    try:
                        self._input_handler(line)
                    except Exception as e:
                        print(e)


    def splash(self):
        print(dedent(f"""
         ____          _       ____   ___  _     
        |  _ \ ___  __| | __ _/ ___| / _ \| |    
        | |_) / _ \/ _` |/ _` \___ \| | | | |    
        |  _ <  __/ (_| | (_| |___) | |_| | |___ 
        |_| \_\___|\__,_|\__,_|____/ \__\_\_____|
                                                 
            - redash query cli tool -

        SUCCESS CONNECT
        - server version {self.get_version()}
        - client version {VERSION}
        """))

    def get_version(self):
        return self.client.get_version()

    def loop(self):
        while True:
            try:
                self.main()
            except RedasqlException as e:
                if self.debug:
                    import traceback
                    print(traceback.format_exc())
                print(e)
                self.input_buffer = []
            except KeyboardInterrupt:
                print('Cancel')
                self.input_buffer = []
            except EOFError:
                print('Sayonara!')
                sys.exit(0)

    def main(self):
        answer = prompt(
            self._get_prompt(),
            history=self.history,
            completer=self._get_completer(),
        )
        self._input_handler(answer)

    def _input_handler(self, input_text: str):
        if self.debug:
            print('buffer', self.input_buffer)
        # ignore empty line.
        if utils.is_empty(input_text):
            return

        self.input_buffer.append(input_text)
        if utils.is_meta_command(input_text):
            self.input_buffer = []
            self.execute_meta_command_handler(input_text)
            return

        if utils.is_sql_end(input_text):
            query = '\n'.join(self.input_buffer)
            self.input_buffer = []
            self.execute_query_handler(query)
            return

    def execute_query_handler(self, query: str):
        if not self.data_source:
            raise NoDataSourceError('Plz set datasource.(use \\c <data source name>)')

        query_result = self._execute_query(
            query=query,
            data_source_id=self.data_source.id
        )
        if query_result.rows_count == 0:
            print(dedent(f"""
            no rows returned.
            {query_result.runtime_for_display}
            """))
            return
        formatted_string = self.formatter(query_result, self.pivoted).format()
        print(formatted_string)
        print(dedent(f"""
        {query_result.rows_count_for_display}
        {query_result.runtime_for_display}
        """))
        if self.output == OutputType.STDOUT_AND_CLIPBOARD:
            copy(formatted_string)

    def execute_meta_command_handler(self, input_string):
        command, *args = re.split(r'\s+', input_string.strip())
        executor = meta_command_factory(command)
        e = executor(self.client, self.data_source, self.pivoted, self.formatter, self.output)
        meta_command_return_list = e.exec(*args)
        if self.debug:
            print(command, args, meta_command_return_list)
        if meta_command_return_list:
            meta_command_return_list.apply(self)

    def _execute_query(self, query: str, data_source_id: int):
        if self.debug:
            print('query', query)
        return self.client.execute_query(
            query=query,
            data_source_id=data_source_id,
            max_age=0,
        )

    def _get_prompt(self):
        data_source_name = '(No DataSource)'
        if self.data_source:
            data_source_name = f'{self.data_source.name}'
        suffix = '-' if self.input_buffer else '='
        return f'{data_source_name}{suffix}# '

    def _get_completer(self):
        return RedasqlCompleter(
            latest_inputs=self.input_buffer,
            words=self.complete_data.get_completer_words(),
            meta_dict=self.complete_data.get_completer_meta_dict()
        )


def main():
    args = init()
    try:
        command = MainCommand(**args.to_dict())
        command.splash()
        command.load_config_from_rc_file()
    except Exception as e:
        print(f'[ERROR] {e}\n')
        sys.exit(1)

    command.loop()


def init():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-k',
        '--api-key',
        help='redash api key',
        default=None,
    )
    parser.add_argument(
        '-s',
        '--server-host',
        help='redash host i.e) https://your-redash-server/',
        default=None,
    )
    parser.add_argument(
        '-d',
        '--data-source',
        help=dedent("""
        initial datasource name.
        if not set, no datasource selected.
        """),
        default=None
    )
    parser.add_argument(
        '-p',
        '--proxy',
        help=dedent("""
        if you need proxy connection, set them
        i.e) http://user:pass@proxy-host:proxy-port'
        """),
        default=None,
    )
    parser.add_argument(
        '--ignore-rc',
        help=dedent("""
        ignore rc file
        """),
        action='store_true',
        default=False,
    )
    parser.add_argument(
        '--debug',
        help=dedent("""
        debug mode on
        """),
        action='store_true',
        default=False,
    )
    args = parser.parse_args()
    return CommandArgs(
        api_key=args.api_key,
        endpoint=args.server_host,
        data_source_name=args.data_source,
        proxy=args.proxy,
        ignore_rc=args.ignore_rc,
        debug=args.debug,
    )


if __name__ == '__main__':
    main()
