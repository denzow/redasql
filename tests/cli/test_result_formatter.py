import datetime
from textwrap import dedent
from unittest import TestCase

from redasql.result_formatter import MarkdownFormatter
from redasql.dto import QueryResultResponse, QueryResultData, QueryResultColumn


class FormatterTest(TestCase):

    def test_markdown_with_linebreak(self):
        mock_query_result_response = QueryResultResponse(
            id=1,
            data_source_id=2,
            retrieved_at=datetime.datetime(2022, 4, 23),
            query_hash='xxxx',
            query='select \'a\na\' col',
            runtime=0.1,
            data=QueryResultData(
                rows=[{'col1': 'a\na', 'col2': 1}],
                columns=[
                    QueryResultColumn(
                        friendly_name='col1',
                        type='string',
                        name='col1',
                    ),
                    QueryResultColumn(
                        friendly_name='col2',
                        type='integer',
                        name='col2',
                    ),
                ]
            )
        )
        formatter = MarkdownFormatter(mock_query_result_response, pivoted=False)
        formatted_string = formatter.format()
        expected = dedent("""\
        | col1    |   col2 |
        |---------|--------|
        | a<br/>a |      1 |""")
        print(formatted_string)
        self.assertEqual(formatted_string, expected)
