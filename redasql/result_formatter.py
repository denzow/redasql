from prettytable import PrettyTable


def table_formatter(result) -> str:
    """
    Table形式で結果を整形して戻す
    :param result:
    :return:
    """

    data = result['query_result']['data']
    column_name_list = [c['name'] for c in data['columns']]
    row_data_list = [r.values() for r in data['rows']]
    x = PrettyTable(
        field_names=column_name_list
    )
    x.add_rows(row_data_list)
    return x.get_string()


def pivoted_formatter(result) -> str:
    """
    リスト形式で結果を整形して戻す
    :param result:
    :return:
    """
    result_string = ''
    data = result['query_result']['data']
    column_name_list = [c['name'] for c in data['columns']]
    row_data_list = data['rows']
    max_col_name_length = max([len(c) for c in column_name_list])

    for i, row in enumerate(row_data_list):
        result_string += f'-[RECORD { i + 1 }]' + '-' * max_col_name_length + '\n'
        for col in column_name_list:
            result_string += f'{col.rjust(max_col_name_length)}: {row[col]}\n'
    return result_string
