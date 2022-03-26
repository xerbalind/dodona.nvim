import requests


class Api:
    def __init__(self, base_url, token) -> None:
        self.base_url = base_url
        self.headers = {
            "Accept": "application/json",
            "Authorization": token,
        }

    def get(self, url, full_path=False):
        if not full_path:
            return requests.get(f"{self.base_url}/{url}", headers=self.headers).json()
        else:
            return requests.get(url, headers=self.headers).json()

    def post(self, url, body):
        return requests.post(
            f"{self.base_url}/{url}", headers=self.headers, json=body
        ).json()
