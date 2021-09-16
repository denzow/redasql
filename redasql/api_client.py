import requests


class ApiClient:

    def __init__(self, redash_url: str, api_key: str):
        self.redash_url = redash_url
        self.session = requests.Session()
        self.session.headers.update({"Authorization": "Key {}".format(api_key)})

    def get_queries(self):
        res = self._get('/api/queries')
        return res.json()

    def get_version(self):
        res = self._get('/api/session')
        res_json = res.json()
        return res_json['client_config']['version']


    def execute_query(self, query: str, data_source_id: int):
        res = self._post('/api/query_results', json={'query': f'{query}', 'data_source_id': data_source_id})
        return res.json()

    def _get(self, path, **kwargs):
        return self._request("GET", path, **kwargs)

    def _post(self, path, **kwargs):
        return self._request("POST", path, **kwargs)

    def _request(self, method, path, **kwargs):
        url = "{}/{}".format(self.redash_url, path)
        response = self.session.request(method, url, **kwargs)
        response.raise_for_status()
        return response

