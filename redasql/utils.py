from typing import Iterable, Any, Tuple


def is_empty(target_str: str):
    return target_str.strip() == ''


def is_sql_end(target_str: str):
    return target_str.strip().endswith(';')


def is_meta_command(target_str: str):
    return target_str.strip().startswith('\\')


def signal_last(it:Iterable[Any]) -> Iterable[Tuple[bool, Any]]:
    iterable = iter(it)
    ret_var = next(iterable)
    for val in iterable:
        yield False, ret_var
        ret_var = val
    yield True, ret_var
