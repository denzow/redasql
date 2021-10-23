from prettytable import PrettyTable

from redasql.dto import QueryResultResponse


def table_formatter(result: QueryResultResponse) -> str:
    """
    return table formatted result
    """
    data = result.data
    column_name_list = [c.name for c in data.columns]
    row_data_list = [r.values() for r in data.rows]
    x = PrettyTable(
        field_names=column_name_list
    )
    x.add_rows(row_data_list)
    return x.get_string()


def pivoted_formatter(result: QueryResultResponse) -> str:
    """
    return pivoted formatted result
    """
    result_string = ''
    data = result.data
    column_name_list = [c.name for c in data.columns]
    row_data_list = data.rows
    max_col_name_length = max([len(c) for c in column_name_list])

    for i, row in enumerate(row_data_list):
        result_string += f'-[RECORD { i + 1 }]' + '-' * max_col_name_length + '\n'
        for col in column_name_list:
            result_string += f'{col.rjust(max_col_name_length)}: {row[col]}\n'
    return result_string
