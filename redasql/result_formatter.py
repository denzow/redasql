from abc import ABC, abstractmethod
from prettytable import PrettyTable

from redasql.constants import FormatterType
from redasql.dto import QueryResultResponse


class Formatter(ABC):
    formatter_type = None

    def __init__(self, result: QueryResultResponse, pivoted: bool):
        self.result = result
        self.pivoted = pivoted
        self.query = result.query
        self.column_name_list = [c.name for c in self.result.data.columns]
        self.rows = self.result.data.rows

    def format(self):
        if self.pivoted:
            return self._format_result_to_column_base()
        return self._format_result_to_row_base()

    @abstractmethod
    def _format_result_to_row_base(self):
        raise NotImplementedError()

    @abstractmethod
    def _format_result_to_column_base(self):
        raise NotImplementedError()


class TableFormatter(Formatter):
    formatter_type = FormatterType.TABLE

    def _format_result_to_row_base(self):
        table = PrettyTable(
            field_names=self.column_name_list
        )
        for row in self.rows:
            row_data = [row[col] for col in self.column_name_list]
            table.add_row(row_data)

        return table.get_string()

    def _format_result_to_column_base(self):
        result_string = ''
        max_col_name_length = max([len(c) for c in self.column_name_list])
        for i, row in enumerate(self.rows):
            result_string += f'-[RECORD {i + 1}]' + '-' * max_col_name_length + '\n'
            for col in self.column_name_list:
                result_string += f'{col.rjust(max_col_name_length)}| {row[col]}\n'
        return result_string


def formatter_factory(formatter_type: FormatterType):
    formatter = FORMATTERS.get(formatter_type)
    return formatter


FORMATTERS = {
    FormatterType.TABLE: TableFormatter,
}
