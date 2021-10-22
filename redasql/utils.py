def is_empty(target_str: str):
    return target_str.strip() == ''


def is_sql_end(target_str: str):
    return target_str.strip().endswith(';')


def is_meta_command(target_str: str):
    return target_str.strip().startswith('\\')
