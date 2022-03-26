class SubmissionManager:
    def __init__(self, api) -> None:
        self.api = api
        pass

    def create(self, submission):
        body = {
            "submission": {
                "code": submission.code,
                "course_id": submission.course,
                "series_id": submission.series,
                "exercise_id": submission.activity,
            },
        }
        return self.api.post("submissions.json", body)


class Submission:
    def __init__(self, file) -> None:
        invoer = open(file, "r")
        url = invoer.readline().strip()
        parts = url.split("/")
        self.course = int(parts[-6])
        self.series = int(parts[-4])
        self.activity = int(parts[-2])

        self.code = invoer.read()
