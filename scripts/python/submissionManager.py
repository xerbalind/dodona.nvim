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
        print(self.api.post("submissions.json", body))


class Submission:
    def __init__(self, file) -> None:
        invoer = open(file, "r")
        url = invoer.readline().strip()
        parts = url.split("/")
        self.course = int(parts[-5])
        self.series = int(parts[-3])
        self.activity = int(parts[-1])

        self.code = invoer.read()
