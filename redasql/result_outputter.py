from abc import ABC
from typing import Optional
from textwrap import dedent

from pyperclip import copy

from redasql.api_client import QueryResultResponse
from redasql.constants import OutputType


class OutPutter(ABC):
    output_type: OutputType = None

    def __init__(self, file_name: Optional[str] = None):
        self.file_name = file_name

    @property
    def info(self):
        raise NotImplementedError()

    def output(self, result_str: str, query_result: QueryResultResponse):
        raise NotImplementedError()


class StdoutOutPutter(OutPutter):
    output_type = OutputType.STDOUT

    @property
    def info(self):
        return f'{self.output_type.value}'

    def output(self, result_str: str, query_result: QueryResultResponse):
        print(result_str)
        print(dedent(f"""
        {query_result.rows_count_for_display}
        {query_result.runtime_for_display}
        """))


class StdoutAndClipboardOutPutter(StdoutOutPutter):
    output_type = OutputType.STDOUT_AND_CLIPBOARD

    def output(self, result_str: str, query_result: QueryResultResponse):
        super().output(result_str, query_result)
        copy(result_str)


class FileOutPutter(StdoutOutPutter):
    output_type = OutputType.FILE

    @property
    def info(self):
        return f'{self.output_type.value}({self.file_name})'

    def output(self, result_str: str, query_result: QueryResultResponse):
        super().output(result_str, query_result)
        with open(self.file_name, 'a') as f:
            f.write(f'{result_str}\n')
            f.write('\n')
            f.write(f'{query_result.rows_count_for_display}\n')
            f.write(f'{query_result.runtime_for_display}\n')


def out_putter_factory(output_type: OutputType, *args, **kwargs):
    out_putter = OUT_PUTTERS.get(output_type)
    return out_putter(*args, **kwargs)


OUT_PUTTERS = {
    OutputType.STDOUT: StdoutOutPutter,
    OutputType.STDOUT_AND_CLIPBOARD: StdoutAndClipboardOutPutter,
    OutputType.FILE: FileOutPutter,
}
