from functools import partial
import re
import fullPokemonCommand
import pokemonCommand

def fullPokemon(username, sock, queue, text):
    fullPokemonCommand.pokemonCommand(username, sock, queue, text)

def pokemon(username, sock, queue, text):
    pokemonCommand.pokemonCommand(username, sock, queue, text)

def noCommand(username, sock, queue, text):
    pass
    
commands = {
    "!fullPokemon" : fullPokemon,
    "!pokemon" : pokemon
}

def parseTextCommand(text):
    command = re.findall("^!.*?\s", text)
    if len(command) > 0:
        return command[0].strip()

def parseTextParams(text):
    splitText = text.split(' ', 1)
    if len(splitText) > 1:
        return splitText[1]

def commandFactory(text):
    return partial(commands.get(parseTextCommand(text), noCommand), text=parseTextParams(text))