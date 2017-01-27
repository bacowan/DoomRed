import proxy
import json
import libs
import cfg
import datetime
import csv
from enum import Enum

class PokemonError(Enum):
    expired = 1
    notThere = 2

movePPs = {}

with open('movePPs.csv', 'r') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        movePPs[row[0]] = row[1]

def getFormattedResult(page):
    proxy.read(page,cfg.PAGES_PER_QUERY)
    
def isExpired(timeString):
    return datetime.datetime.utcnow() - datetime.timedelta(minutes=cfg.SUBMISSION_EXPIRY_TIME_MIN) > datetime.datetime.strptime(timeString, "%Y-%m-%dT%H:%M:%SZ")

def pokemonFromResult(jsonResult, code):
    if len(jsonResult) == 0:
        return None, PokemonError.notThere
    for result in jsonResult:
        print result
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

def formatInput(inputValue):
    output = ""
    # name
    for i in xrange(0,10):
        if len(inputValue['Name']) > i:
            output += inputValue['Name'][i]
        else:
            output += "\t"
    print (inputValue)
    # attacks
    output += "{:0>3d}".format(int(inputValue['Attack1']))
    output += "{:0>3d}".format(int(inputValue['Attack2']))
    output += "{:0>3d}".format(int(inputValue['Attack3']))
    output += "{:0>3d}".format(int(inputValue['Attack4']))
    # PP
    output += "{:0>3d}".format(int(movePPs[inputValue['Attack1']]))
    output += "{:0>3d}".format(int(movePPs[inputValue['Attack2']]))
    output += "{:0>3d}".format(int(movePPs[inputValue['Attack3']]))
    output += "{:0>3d}".format(int(movePPs[inputValue['Attack4']]))
    # Types
    output += "{:0>2d}".format(int(inputValue['Type1']))
    output += "{:0>2d}".format(int(inputValue['Type2']))
    # Abilities
    output += "{:0>2d}".format(int(inputValue['Ability']))
    return output

def pokemonCommand(username, sock, queue, text):
    libs.chat(sock, "kudWafu")
    jsonPokemon, error = getInputFromBitBalloon(text)
    if error != True:
        libs.chat(sock, "That pokemon has either expired or does not exist.")
    if jsonPokemon != None:
        formattedInput = formatInput(jsonPokemon)
        if (validate(formattedInput) and approve(formattedInput)):
            queue.put(formattedInput.encode("ascii","ignore"))

def validate(formattedInput):
    return True

def approve(formattedInput):
    return True