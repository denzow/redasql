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
    data = result['query_result']['data']
    column_name_list = [c['name'] for c in data['columns']]
    row_data_list = data['rows']
    for row in row_data_list:
        print(row)

