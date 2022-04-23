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
                rows=[{'col': 'a\na'}],
                columns=[QueryResultColumn(
                    friendly_name='col',
                    type='string',
                    name='col',
                )]
            )
        )
        formatter = MarkdownFormatter(mock_query_result_response, pivoted=False)
        formatted_string = formatter.format()
        expected = dedent("""\
        | col     |
        |---------|
        | a<br/>a |""")
        self.assertEqual(formatted_string, expected)
