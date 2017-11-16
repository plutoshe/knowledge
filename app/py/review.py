import requests
import time
import json
ticks = int(time.time()) + 86400
url = "http://127.0.0.1:16759/review?now=" + str(ticks)
print(url)
r = requests.get(url)
d = json.loads(r.content)

udpate_url = "http://127.0.0.1:16759/record"
for item in d:
    for text in item["front"]:
        print(text["data"])
    remember = raw_input("remember? default:y\n")
    for text in item["back"]:
        print(text["data"])
    reminder = int(item["reminder"])
    original_date = ticks - reminder * 86400
    modify = True
    if remember == "n":
        reminder = 1
        review_date = original_date + reminder * 86400
    else:
        print(reminder)
        print(item["review_date"])
        if reminder > 0 & item["review_date"]:
            modify = False
        elif reminder != 31:
            reminder = reminder * 2 + 1
            review_date = original_date + reminder * 86400
        else:
            reminder = -1
            review_date = original_date + reminder * 86400
    if modify:
        value = {
            "query": {"record_id": item["record_id"]},
            "update": {
                "reminder": reminder,
                "review_date": review_date,
            }
        }
        print(value)
        pass


