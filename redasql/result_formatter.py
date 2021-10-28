import csv
from abc import ABC, abstractmethod
from io import StringIO

import tabulate

from redasql.constants import FormatterType
from redasql.dto import QueryResultResponse

tabulate.PRESERVE_WHITESPACE = True


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
        row_for_tables = []
        for row in self.rows:
            row_for_tables.append([row[c] for c in self.column_name_list])
        table = tabulate.tabulate(
            row_for_tables,
            headers=self.column_name_list,
            tablefmt='psql'
        )
        return table

    def _format_result_to_column_base(self):
        result_string = ''
        max_col_name_length = max([len(c) for c in self.column_name_list])
        for i, row in enumerate(self.rows):
            result_string += f'-[RECORD {i + 1}]' + '-' * max_col_name_length + '\n'
            for col in self.column_name_list:
                result_string += f'{col.rjust(max_col_name_length)}| {row[col]}\n'
        return result_string


class MarkdownFormatter(Formatter):
    formatter_type = FormatterType.MARKDOWN

    def _format_result_to_row_base(self):
        row_for_tables = []
        for row in self.rows:
            row_for_tables.append([row[c] for c in self.column_name_list])
        table = tabulate.tabulate(
            row_for_tables,
            headers=self.column_name_list,
            tablefmt='github'
        )
        return table

    def _format_result_to_column_base(self):
        row_for_tables = []
        for row in self.rows:
            for k, v in row.items():
                row_for_tables.append([k, v])

        table = tabulate.tabulate(
            row_for_tables,
            headers=['colum_name', 'value'],
            tablefmt='github'
        )
        return table


class MarkdownWithSQLFormatter(MarkdownFormatter):
    formatter_type = FormatterType.MARKDOWN_WITH_SQL

    def _format_result_to_row_base(self):
        table = super()._format_result_to_row_base()
        result = f"""
```sql
{self.query}
```

{table}"""
        return result


    def _format_result_to_column_base(self):
        table = super()._format_result_to_column_base()
        result = f"""
```sql
{self.query}
```

{table}"""
        return result


class CSVFormatter(MarkdownFormatter):
    formatter_type = FormatterType.CSV

    def _format_result_to_row_base(self):
        with StringIO() as f:
            writer = csv.DictWriter(f, fieldnames=self.column_name_list)
            writer.writeheader()
            for row in self.rows:
                writer.writerow(row)
            return f.getvalue()

    def _format_result_to_column_base(self):
        print('[warn] csv format not suppported pivot')
        return self._format_result_to_row_base()


def formatter_factory(formatter_type: FormatterType):
    formatter = FORMATTERS.get(formatter_type)
    return formatter


FORMATTERS = {
    FormatterType.TABLE: TableFormatter,
    FormatterType.MARKDOWN: MarkdownFormatter,
    FormatterType.MARKDOWN_WITH_SQL: MarkdownWithSQLFormatter,
    FormatterType.CSV: CSVFormatter,
}
