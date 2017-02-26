import libs
import pokemonCommandLibs
from random import randint

def generatePokemon(text):
    params = text.split()
    ret = {}
    ret['Attack1'] = str(randint(0, pokemonCommandLibs.attackCount))
    ret['Attack2'] = str(randint(0, pokemonCommandLibs.attackCount))
    ret['Attack3'] = str(randint(0, pokemonCommandLibs.attackCount))
    ret['Attack4'] = str(randint(0, pokemonCommandLibs.attackCount))
    ret['Ability'] = str(randint(1, pokemonCommandLibs.abilityCount))
    ret['Gender'] = str(randint(0, 2))
    ret['Moves Learnable'] = {}
    movesLearnableCount = randint(10, 20)
    for i in range(1,movesLearnableCount):
        ret['Moves Learnable'][i] = {}
        ret['Moves Learnable'][i]["'level'"] = str(randint(1,60))
        ret['Moves Learnable'][i]["'move'"] = str(randint(1, pokemonCommandLibs.attackCount))
    ret['Image Link'] = params[0]
    ret['Name'] = params[0]
    if len(params) == 1:
        ret['Type1'] = str(randint(0, pokemonCommandLibs.typesCount - 1))
        ret['Type2'] = str(randint(0, pokemonCommandLibs.typesCount - 1))
    elif len(params) == 2:
        ret['Type1'] = str(pokemonCommandLibs.types[params[1]])
        ret['Type2'] = str(ret['Type1'])
    else:
        ret['Type1'] = str(pokemonCommandLibs.types[params[1]])
        ret['Type2'] = str(pokemonCommandLibs.types[params[2]])
    return ret, True


def pokemonCommand(username, sock, queue, text):
    libs.chat(sock, "kudWafu")
    jsonPokemon, error = generatePokemon(text)
    if error != True:
        libs.chat(sock, "That pokemon has either expired or does not exist.")
    if jsonPokemon != None:
        formattedInput = pokemonCommandLibs.formatInput(jsonPokemon)
        if (validate(formattedInput) and approve(formattedInput)):
            queue.put(formattedInput.encode("ascii", "ignore"))


def validate(formattedInput):
    return True


def approve(formattedInput):
    return True