import logging

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

    def __init__(
        self,
        redash_url: str,
        api_key: str,
        proxy: str = None,
        wait_interval_sec: float = 0,
        timeout_count: Optional[int] = 600,
        debug: bool = False
    ):
        self.redash_url = redash_url.rstrip('/')
        self.api_key = api_key
        self.proxy = proxy
        self._create_session()
        self.wait_interval_sec = wait_interval_sec
        self.timeout_count = timeout_count
        if debug:
            import logging
            import http.client as http_client
            requests_log = logging.getLogger("requests.packages.urllib3")
            requests_log.setLevel(logging.DEBUG)
            fmt = "[DEBUG LOGGING][%(asctime)s] %(levelname)s %(name)s :%(message)s"
            logging.basicConfig(level=logging.DEBUG, format=fmt)
            http_client.HTTPConnection.debuglevel = 1
        self._version: Optional[str] = None

    @property
    def version(self):
        if not self._version:
            self._version = self.get_version()
        return self._version

    @property
    def major_version(self) -> int:
        return int(self.version.split('.')[0])

    @property
    def minor_version(self) -> int:
        return int(self.version.split('.')[0])

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

    def get_schema(self, data_source_id: int, refresh: bool = True) -> List[SchemaResponse]:
        param = ''
        if refresh:
            param = '?refresh=true'
        res = self._get(f'api/data_sources/{data_source_id}/schema{param}')
        res_json = res.json()
        # over redash ver10 return job, when refresh = true.
        if 'job' in res_json:
            return self._wait_job_for_schema(
                res_json['job']['id'],
                timeout=self.timeout_count,
                wait_interval_sec=self.wait_interval_sec
            )

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
            self, query: str, data_source_id: int, max_age: int = -1
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
        return self._wait_job(job_id, self.timeout_count, self.wait_interval_sec)

    def _create_session(self):
        self.session = requests.Session()
        self.session.headers.update({'Authorization': f'Key {self.api_key}'})
        if self.proxy:
            self.session.proxies.update({'http': self.proxy, 'https': self.proxy})

    def _wait_job(self, job_id: str, timeout: int, wait_interval_sec: float):
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

            time.sleep(wait_interval_sec)
            retry_counter += 1
            if retry_counter > timeout:
                raise QueryTimeoutError(f'Wait Query Complete. but not completed[{timeout}].')

    def _wait_job_for_schema(self, job_id: str, timeout: int, wait_interval_sec: float):
        retry_counter = 0
        while True:
            res = self._get(f'api/jobs/{job_id}')
            res_json = res.json()

            # 3: success
            if res_json.get('job', {}).get('status') == 3:
                schema_result = res_json['job']['result']
                return [SchemaResponse.from_response(s) for s in schema_result]

            # 4: error
            if res_json.get('job', {}).get('status') == 4:
                error_msg = res_json['job']['error']
                raise QueryRuntimeError(error_msg)
            time.sleep(wait_interval_sec)
            retry_counter += 1
            if retry_counter > timeout:
                raise QueryTimeoutError(f'Wait Query Complete. but not completed[{timeout} * {wait_interval_sec}].')

    def _get(self, path, **kwargs):
        return self._request('GET', path, **kwargs)

    def _post(self, path, **kwargs):
        return self._request('POST', path, **kwargs)

    def _request(self, method, path, **kwargs):
        url = '{}/{}'.format(self.redash_url, path)
        retry_count = 0
        max_retry = 3
        latest_error = None
        while retry_count <= max_retry:
            try:
                response = self.session.request(method, url, **kwargs)
                response.raise_for_status()
                return response
            except requests.exceptions.ConnectionError as e:
                retry_count += 1
                latest_error = e
                print(f'reconnect[{retry_count}] because of [{e}]')
                self._create_session()

        raise latest_error
