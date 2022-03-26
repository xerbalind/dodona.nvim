from os.path import exists, expanduser
import os
from activitymanager import ActivityManager
from submissionManager import *
from api import Api
import argparse

# Config

# TOKEN = "YiYx23h1ZA5gabUbliAx3KZtPuzf9068Cf8vgUndH2g"
# BASE_URL = "https://dodona.ugent.be"
SERIE = 12986
CONFIG_PATH = expanduser("~") + "/.dodona-config"


# Create Files in series
def structInit(activities, path):
    for activity in activities:
        file_name = (
            f"{activity['name']}.{activity['programming_language']['extension']}"
        ).replace(" ", "_")

        if not exists(file_name):
            with open(os.path.join(path, file_name), "w") as f:
                f.write(f"#{activity['url'][:-5]}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    # Add arguments
    parser.add_argument(
        "--command", choices=["init", "submit"], type=str, required=True
    )
    parser.add_argument("--series", type=int, help="The id of the series")
    parser.add_argument("--path", type=str, required=True)

    # Parse the argument
    args = parser.parse_args()

    # Get token or ask is it doesnt't exist yet
    if not exists(CONFIG_PATH):
        TOKEN = input("Token: ")
        BASE_URL = input("URL: ")
        with open(CONFIG_PATH, "w+") as f:
            f.writelines([TOKEN + "\n", BASE_URL + "\n"])
    else:
        with open(CONFIG_PATH) as f:
            TOKEN = f.readline().strip()
            BASE_URL = f.readline().strip()

    api = Api(BASE_URL, TOKEN)
    activitymanager = ActivityManager(api)

    if args.command == "init":
        assert args.series is not None, "Series id required for this command!!"
        structInit(activitymanager.getActivities(args.series), args.path)

    elif args.command == "submit":
        submission = Submission(args.path)
        manager = SubmissionManager(api)
        manager.create(submission)
