import proxy
import json
import libs
import cfg
import datetime
import pokemonCommandLibs
from enum import Enum

class PokemonError(Enum):
    expired = 1
    notThere = 2
    
def isExpired(timeString):
    return datetime.datetime.utcnow() - datetime.timedelta(minutes=cfg.SUBMISSION_EXPIRY_TIME_MIN) > datetime.datetime.strptime(timeString, "%Y-%m-%dT%H:%M:%SZ")

def pokemonFromResult(jsonResult, code):
    if len(jsonResult) == 0:
        return None, PokemonError.notThere
    for result in jsonResult:
        print(result)
        if isExpired(result['created_at']):
            return None, PokemonError.expired
        if result['id'] == code:
            return (result['human_fields'], True)
    return None, True

def pokemonFromWeb(i, code):
    jsonResult = json.loads(proxy.read(i,cfg.PAGES_PER_QUERY))
    return pokemonFromResult(jsonResult, code)

def getInputFromBitBalloon(code):
    i = 1
    jsonPokemon, more = pokemonFromWeb(i,code)
    while jsonPokemon == None and more == True:
        i += 1
        jsonPokemon, more = pokemonFromWeb(i,code)
    return (jsonPokemon, more)



def pokemonCommand(username, sock, queue, text):
    libs.chat(sock, "kudWafu")
    jsonPokemon, error = getInputFromBitBalloon(text)
    if error != True:
        libs.chat(sock, "That pokemon has either expired or does not exist.")
    if jsonPokemon != None:
        formattedInput = pokemonCommandLibs.formatInput(jsonPokemon)
        if (validate(formattedInput) and approve(formattedInput)):
            queue.put(input.encode("ascii", "ignore"))

def validate(formattedInput):
    return True

def approve(formattedInput):
    return True