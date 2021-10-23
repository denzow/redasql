class RedasqlException(Exception):
    """ base exception """


class QueryRuntimeError(RedasqlException):
    """ redash said, sql error """


class QueryTimeoutError(RedasqlException):
    """ too long """


class DataSourceNotFoundError(RedasqlException):
    """ not found datasource name """


class InvalidMetaCommand(RedasqlException):
    """ invalid meta command"""


class InsufficientParametersError(RedasqlException):
    """ api key and endpoint must be set """
