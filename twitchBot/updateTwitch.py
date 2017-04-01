import urllib.request
import json
import os

url = "https://twitchemotes.com/api_cache/v2/images.json"

def getAllEmotes():
    try:
        os.remove('emotes.json')
    except:
        pass
    result = json.loads(urllib.request.urlopen(url).read())
    with open('emotes.json', 'w') as outfile:
        json.dump(result, outfile)

if __name__ == "__main__":
    getAllEmotes()