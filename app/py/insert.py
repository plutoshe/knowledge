
url = "http://127.0.0.1:16759/record"
while (True):
    answer = raw_input("raw_input(y/n) default y?")
    print(answer)
    if answer == "n":
        break
    content = []
    while (True):
        addcontent = raw_input("content? default:y")
        if addcontent == "n":
            break
        cover = raw_input("cover(0:front, 1:back) default:0")
        data = raw_input("data?")
        if cover != "1":
            cover = 0
        content.append({"cover": int(cover), "data": data, "form": "TEXT"})
    tags = []
    while (True):
        addtag = raw_input("tags?")
        if addtag == "n":
            break
        tag = raw_input("tag?")
        if tag == "":
            break
        tags.append(tag)
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


