import requests
import time
from typing import Optional, List

from redasql.dto import (
    DataSourceResponse,
    QueryResultResponse,
    SchemaResponse,
    QueryResponse
)
from redasql.exceptions import (
    QueryRuntimeError,
    DataSourceNotFoundError,
    QueryTimeoutError,
)


class ApiClient:

    def __init__(self, redash_url: str, api_key: str, proxy: str = None, debug: bool = False):
        self.redash_url = redash_url.rstrip('/')
        self.session = requests.Session()
        self.session.headers.update({'Authorization': f'Key {api_key}'})
        self.proxy = None
        if proxy:
            self.proxy = proxy
        if self.proxy:
            self.session.proxies.update({'http': self.proxy, 'https': self.proxy})
        if debug:
            import logging
            import http.client as http_client
            requests_log = logging.getLogger("requests.packages.urllib3")
            requests_log.setLevel(logging.DEBUG)
            fmt = "[DEBUG LOGGING][%(asctime)s] %(levelname)s %(name)s :%(message)s"
            logging.basicConfig(level=logging.DEBUG, format=fmt)
            http_client.HTTPConnection.debuglevel = 1

    def get_data_sources(self) -> List[DataSourceResponse]:
        res = self._get('api/data_sources')
        res_json = res.json()
        return [DataSourceResponse.from_response(ds) for ds in res_json]

    def get_data_source_by_name(self, name: str) -> Optional[DataSourceResponse]:
        for ds in self.get_data_sources():
            if ds.name == name:
                return ds
        raise DataSourceNotFoundError(f'data source name [{name}] is not found.')

    def get_data_source_by_id(self, data_source_id: int) -> Optional[DataSourceResponse]:
        for ds in self.get_data_sources():
            if ds.id == data_source_id:
                return ds
        raise DataSourceNotFoundError(f'data source id [{data_source_id}] is not found.')

    def get_schema(self, data_source_id: int) -> List[SchemaResponse]:
        res = self._get(f'api/data_sources/{data_source_id}/schema')
        if 'schema' not in res.json():
            return []
        return [SchemaResponse.from_response(s) for s in res.json()['schema']]

    def get_queries(self):
        res = self._get('api/queries')
        return res.json()

    def get_query_by_id(self, query_id: int) -> QueryResponse:
        res = self._get(f'api/queries/{query_id}')
        return QueryResponse.from_response(res.json())

    def get_version(self):
        res = self._get('api/session')
        res_json = res.json()
        return res_json['client_config']['version']

    def get_query_result(self, query_result_id: int) -> QueryResultResponse:
        res = self._get(f'api/query_results/{query_result_id}')
        return QueryResultResponse.from_response(res.json()['query_result'])

    def execute_query(
            self, query: str, data_source_id: int, max_age: int = -1, timeout=10*60
    ) -> QueryResultResponse:
        res = self._post(
            'api/query_results',
            json={
                'query': f'{query}',
                'data_source_id': data_source_id,
                'max_age': max_age,
            }
        )
        res_json = res.json()
        # has result
        if 'query_result' in res_json:
            return QueryResultResponse.from_response(res_json['query_result'])

        # no result, wait execution.
        job_id = res_json['job']['id']
        return self._wait_job(job_id, timeout)

    def _wait_job(self, job_id: str, timeout: int):
        retry_counter = 0
        while True:
            res = self._get(f'api/jobs/{job_id}')
            res_json = res.json()

            # 3: success
            if res_json.get('job', {}).get('status') == 3:
                query_result_id = res_json['job']['query_result_id']
                return self.get_query_result(query_result_id)

            # 4: error
            if res_json.get('job', {}).get('status') == 4:
                error_msg = res_json['job']['error']
                raise QueryRuntimeError(error_msg)

            retry_counter += 1
            if retry_counter > timeout:
                raise QueryTimeoutError(f'Wait Query Complete. but not completed[{timeout}].')
            time.sleep(0.1)

    def _get(self, path, **kwargs):
        return self._request('GET', path, **kwargs)

    def _post(self, path, **kwargs):
        return self._request('POST', path, **kwargs)

    def _request(self, method, path, **kwargs):
        url = '{}/{}'.format(self.redash_url, path)
        response = self.session.request(method, url, **kwargs)
        response.raise_for_status()
        return response
