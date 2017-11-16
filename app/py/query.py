url = "http://127.0.0.1:16759/record?tag="

import requests

tags = []
while (True):
    tag = raw_input("tag(exit quit this mode)?")
    if tag == "exit" or tag == "":
        break
    tags.append(tag)

values = {
    "tags": tags,
    # "query_method": "tag",
}

print(url + ",".join(tags))
r = requests.get(url + ",".join(tags))
print(r)
print(r.content)
