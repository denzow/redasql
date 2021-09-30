class RedasqlException(Exception):
    """ 基底エラー例外 """


class QueryRuntimeError(RedasqlException):
    """ クエリ実行時のエラー """
