from unittest import TestCase

from redasql.utils import (
    extract_query_parameter_names,
    replace_query_parameter,
    render_query_parameters,
    parse_variable_argument,
)


class QueryParameterTest(TestCase):
    """
    no docker required.
    """

    def test_extract_names(self):
        query = "select * from t where a = '{{a}}' and b = {{ b }} and c = {{a}} and d = {{ range.start }}"
        self.assertEqual(['a', 'b', 'range.start'], extract_query_parameter_names(query))

    def test_extract_names__no_parameters(self):
        self.assertEqual([], extract_query_parameter_names('select 1;'))

    def test_replace_parameter__literal_value(self):
        query = "select '{{ a }}', '{{a}}'"
        # backslash and group reference must be kept literally.
        self.assertEqual(
            "select 'x\\1y', 'x\\1y'",
            replace_query_parameter(query, 'a', 'x\\1y'),
        )

    def test_replace_parameter__only_matched_name(self):
        query = "select {{ a }}, {{ ab }}"
        self.assertEqual("select 1, {{ ab }}", replace_query_parameter(query, 'a', '1'))

    def test_render_query_parameters(self):
        query = "select * from t where a = {{ a }} and b = '{{b}}'"
        rendered = render_query_parameters(query, {'a': '1', 'b': 'foo'})
        self.assertEqual("select * from t where a = 1 and b = 'foo'", rendered)

    def test_parse_variable_argument(self):
        self.assertEqual(('a', '1'), parse_variable_argument('a=1'))
        self.assertEqual(('a', 'x=y'), parse_variable_argument('a=x=y'))
        self.assertEqual(('a', ''), parse_variable_argument('a='))

    def test_parse_variable_argument__invalid(self):
        with self.assertRaises(ValueError):
            parse_variable_argument('a')
        with self.assertRaises(ValueError):
            parse_variable_argument('=1')
