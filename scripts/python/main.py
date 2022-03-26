from os.path import exists, expanduser
import os
from activitymanager import ActivityManager
from submissionManager import *
from api import Api
import argparse
import time

# Config


CONFIG_PATH = expanduser("~") + "/.dodona-config"

# Colors for in terminal
class bcolors:
    OKGREEN = "\033[92m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"


# Create Files in series
def structInit(activities, path):
    for i, activity in enumerate(activities):
        file_name = (
            f"{i}_{activity['name']}.{activity['programming_language']['extension']}"
        ).replace(" ", "_")

        if not exists(file_name):
            with open(os.path.join(path, file_name), "w") as f:
                f.write(f"#{activity['url'][:-5]}/\n")

    print(f"{bcolors.OKGREEN}Activity files successfully created{bcolors.ENDC}")


# Send submission to dodona using api
def evaluateSubmission(manager, submission):
    response = manager.create(submission)

    print("Solution has been submitted")
    print("Evaluating...")
    for _ in range(10):
        time.sleep(2)  # sleep 2 seconds before checking if solution has been executed
        result = manager.api.get(response["url"], full_path=True)
        if result["status"] not in ["running", "queued"]:
            if result["status"] != "correct":
                color = bcolors.FAIL
            else:
                color = bcolors.OKGREEN

            print(f"{color}{result['status']}: {result['summary']}{bcolors.ENDC}")
            print(result["url"][:-5])

            return

    print("timeout!!")


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
        evaluateSubmission(manager, submission)
