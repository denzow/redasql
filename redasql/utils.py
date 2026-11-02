import re
from typing import Iterable, Any, Tuple, List, Dict

# redash query parameter. i.e) {{ name }}, {{name}}, {{ range.start }}
QUERY_PARAMETER_PATTERN = re.compile(r'{{\s*([^{}]+?)\s*}}')


def is_empty(target_str: str):
    return target_str.strip() == ''


def is_sql_end(target_str: str):
    return target_str.strip().endswith(';')


def is_meta_command(target_str: str):
    return target_str.strip().startswith('\\')


def extract_query_parameter_names(query: str) -> List[str]:
    """
    extract `{{ name }}` parameter names from query.
    unique, keep order of first appearance.
    """
    names = []
    for name in QUERY_PARAMETER_PATTERN.findall(query):
        if name not in names:
            names.append(name)
    return names


def replace_query_parameter(query: str, name: str, value: str) -> str:
    """
    replace all `{{ name }}` in query with value.
    value is used literally (not as regex replacement string).
    """
    pattern = re.compile(r'{{\s*' + re.escape(name) + r'\s*}}')
    return pattern.sub(lambda _: value, query)


def render_query_parameters(query: str, parameters: Dict[str, str]) -> str:
    for name, value in parameters.items():
        query = replace_query_parameter(query, name, value)
    return query


def parse_variable_argument(argument: str) -> Tuple[str, str]:
    """
    parse `NAME=VALUE` style argument.
    """
    name, separator, value = argument.partition('=')
    name = name.strip()
    if not separator or not name:
        raise ValueError(f'[{argument}] is invalid variable format. use NAME=VALUE.')
    return name, value


def signal_last(it: Iterable[Any]) -> Iterable[Tuple[bool, Any]]:
    iterable = iter(it)
    ret_var = next(iterable)
    for val in iterable:
        yield False, ret_var
        ret_var = val
    yield True, ret_var
