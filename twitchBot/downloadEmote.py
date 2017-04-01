import math
import json
import urllib.request
import urllib.error
import io
import array
import os

from lszz.compress import compress
from PIL import Image

twitchUrl = "https://static-cdn.jtvnw.net/emoticons/v1/{}/1.0"
ffzUrl = "https://cdn.frankerfacez.com/emoticon/{}/{}"
currentDir = os.path.dirname(__file__)
twitchEmotesFilePath = os.path.join(currentDir, 'emotes.json')
ffzEmotesFilePath = os.path.join(currentDir, 'ffz.json')

with open(twitchEmotesFilePath) as file:
    data = json.load(file)
codeToId = {data["images"][i]["code"]: i for i in data["images"]}

with open(ffzEmotesFilePath) as ffzFile:
    ffzCodeData = json.load(ffzFile)

def tile(im):
    tiled = []
    tileSize = 8
    horizontalTileCount = im.size[0]/8
    verticalTileCount = im.size[0] / 8
    data = list(im.getdata())
    for i in range(math.floor(horizontalTileCount)):
        for j in range(math.floor(verticalTileCount)):
            for k in range(tileSize*tileSize):
                tiled.append(data[
                                 math.floor(i*im.size[0]*tileSize + # for each vertical tile
                                            j*tileSize + # for each horizontal tile
                                            k%tileSize + # for each horizontal pixel in each tile
                                            math.floor(k/tileSize)*im.size[0]) # for each vertical pixel in each tile
                             ])
    tiledAsBytes = []
    for i in range(0, len(tiled), 2):
        tiledAsBytes.append(tiled[i] + tiled[i + 1] * 16)

    return tiledAsBytes

def toXRGB(pal):
    ret = []
    for i in range(15):
        ret.append([pal[(3*i)+2], pal[(3*i)+1], pal[3*i]])
    return ret

def shorten(bytes):
    ret = []
    for i in range(len(bytes)):
        twoBytes = (bytes[i][0] >> 3 << 10) + (bytes[i][1] >> 3 << 5) + (bytes[i][2] >> 3)
        ret.append([twoBytes & 0xFF, twoBytes >> 8])
    return ret

def downloadTwitchEmote(emoteName):
    emoteId = codeToId[emoteName]
    return urllib.request.urlopen(twitchUrl.format(emoteId)).read()

def downloadFfzEmote(emoteName):
    emoteId = ffzCodeData[emoteName]
    try:
        return urllib.request.urlopen(ffzUrl.format(emoteId, 2)).read()
    except urllib.error.HTTPError: # some ffz emotes don't have a x2 res
        return urllib.request.urlopen(ffzUrl.format(emoteId, 1)).read()

def downloadEmote(emoteName):
    if emoteName in codeToId:
        return downloadTwitchEmote(emoteName)
    elif emoteName in ffzCodeData:
        return downloadFfzEmote(emoteName)
    else:
        return None

def getEmote(emoteName):
    rawDownload = downloadEmote(emoteName)
    if rawDownload == None:
        raise NoEmoteException()
    bytes = io.BytesIO(rawDownload)
    rawImage = Image.open(bytes).resize((64,64))

    bmpImage = Image\
        .composite(rawImage, Image.new('RGB', rawImage.size, (0,0,0)), rawImage)\
        .convert('P', palette=Image.ADAPTIVE, colors=15) # adding a black background can give images "outlines"
    bmpImage.putpalette([255,0,0] + bmpImage.getpalette()[:-3]) # make space for the alpha color. I'm using red just for debugging visualization purposes
    bmpImage.putdata([i+1 for i in bmpImage.getdata()])

    bmpData = bmpImage.getdata()
    pngData = rawImage.getdata()

    bmpImage.putdata([0 if pngData[i][3] == 0 else bmpData[i] for i in range(len(pngData))])

    palette = bmpImage.getpalette()
    xRGB = toXRGB(palette)
    shortenedPalette = shorten(xRGB)
    flattenedPalette = [x for y in shortenedPalette for x in y]

    icon = bmpImage.copy().resize((32, 32))

    tiledBytes = tile(bmpImage)
    tileIconBytes = tile(icon)

    compressedPalette = io.BytesIO()
    compress(flattenedPalette, compressedPalette)
    compressedBytes = io.BytesIO()
    compress(tiledBytes, compressedBytes)
    iconBytes = io.BytesIO(array.array('B', tileIconBytes))

    return compressedPalette, compressedBytes, iconBytes

if __name__ == "__main__":
    getEmote("theosPaint")

class NoEmoteException(Exception):
    pass