class ActivityManager:
    def __init__(self, api) -> None:
        self.api = api

    def getActivities(self, serie):
        return self.api.get(f"series/{serie}/activities.json")
