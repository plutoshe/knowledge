
url = "http://127.0.0.1:16759/record"
while (True):
    answer = raw_input("raw_input(y/n) default y?")
    print(answer)
    if answer == "n":
        break
    content = []

    data = raw_input("front?")
    content.append({"cover": 0, "data": data, "form": "TEXT"})
    data = raw_input("back?")
    content.append({"cover": 1, "data": data, "form": "TEXT"})
    tag = raw_input("tag?")
    tags = tag.split(",")
    if tag == "":
        tags = []


    reminder = raw_input("remind?(default:1)")
    if reminder == "":
        reminder = 1
    reminder = int(reminder)
    value = {
        "content": content,
        "tags": tags,
        "reminder": reminder,
    }
    print(value)
    import requests
    r = requests.post(url, json=value)


