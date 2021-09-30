import requests
import time

from redasql.exceptions import QueryRuntimeError


class ApiClient:

    def __init__(self, redash_url: str, api_key: str):
        self.redash_url = redash_url
        self.session = requests.Session()
        self.session.headers.update({"Authorization": "Key {}".format(api_key)})

    def get_schemas(self, data_source_id: int):
        res = self._get(f'/api/data_sources/{data_source_id}/schema')
        return res.json()

    def get_queries(self):
        res = self._get('/api/queries')
        return res.json()

    def get_version(self):
        res = self._get('/api/session')
        res_json = res.json()
        return res_json['client_config']['version']

    def get_query_result(self, query_result_id: int):
        res = self._get(f'/api/query_results/{query_result_id}')
        return res.json()

    def execute_query(self, query: str, data_source_id: int):
        res = self._post('/api/query_results', json={'query': f'{query}', 'data_source_id': data_source_id})
        res_json = res.json()
        # 結果がある場合
        if 'query_result' in res_json:
            return res_json

        # 結果がない場合はJOB完了を待つしかない
        job_id = res_json['job']['id']
        return self._wait_job(job_id)

    def _wait_job(self, job_id: str):
        while True:
            res = self._get(f'/api/jobs/{job_id}')
            res_json = res.json()

            # 3: success
            if res_json.get('job', {}).get('status') == 3:
                query_result_id = res_json['job']['query_result_id']
                return self.get_query_result(query_result_id)

            # 4: error
            if res_json.get('job', {}).get('status') == 4:
                error_msg = res_json['job']['error']
                raise QueryRuntimeError(error_msg)

            time.sleep(1)

    def _get(self, path, **kwargs):
        return self._request("GET", path, **kwargs)

    def _post(self, path, **kwargs):
        return self._request("POST", path, **kwargs)

    def _request(self, method, path, **kwargs):
        url = "{}/{}".format(self.redash_url, path)
        response = self.session.request(method, url, **kwargs)
        response.raise_for_status()
        return response
