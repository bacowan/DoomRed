from functools import partial
import re
import fullPokemonCommand
import pokemonCommand
import cfg
import validators
import libs
import time

class CurrentTime:
    def __init__(self):
        self.now = 0
    def update(self):
        self.now = int(time.time())
    def compareToNow(self):
        return int(time.time()) - self.now

validators = {
    'repeats': validators.AllowRepeats(cfg.DEFAULT_ALLOW_REPEATS),
    'userLimit': validators.UserLimit(cfg.DEFAULT_USER_LIMIT)
}

streamerName = cfg.CHAN.strip()[1:].lower()
now = CurrentTime()

#def fullPokemon(username, sock, queue, text):
#    fullPokemonCommand.pokemonCommand(username, sock, queue, text)

def pokemon(username, sock, queue, text):
    pokemonCommand.pokemonCommand(username, sock, queue, text, validators)

def toggleRepeats(username, sock, queue, text):
    if (username.lower() == streamerName):
        newValue = not validators['repeats'].allow
        validators['repeats'].allow = newValue
        if newValue:
            outputText = "Repeat emotes are now enabled"
        else:
            outputText = "Repeat emotes are now disabled"
        libs.chat(sock, outputText)

def userLimit(username, sock, queue, text):
    if (username.lower() == streamerName):
        try:
            validators['userLimit'].limit = int(text)
            libs.chat(sock, "Max Pokemon in queue per user has been set to " + str(text))
        except ValueError:
            libs.chat(sock, "That is not a valid integer.")


def helpCommand(username, sock, queue, text):
    if (now.compareToNow() > cfg.HELP_COOLDOWN_SECONDS):
        libs.chat(sock, "Welcome to Pokemon DoomRed, the Pokemon game where Twitch chat creates the Pokemon! Type !pokemon (emote) or !pokemon (emote) (type1) (type2) to create a Pokemon! Any Twitch emotes or FFZ emotes will work.")
        now.update()

def noCommand(username, sock, queue, text):
    pass
    
commands = {
    #"!fullPokemon" : fullPokemon,
    "!pokemon": pokemon,
    "!toggleRepeats": toggleRepeats,
    "!setUserLimit": userLimit,
    "!help": helpCommand
}

def parseTextCommand(text):
    command = re.findall("^!.*", text)
    if len(command) > 0:
        return command[0].split()[0]

def parseTextParams(text):
    splitText = text.split(' ', 1)
    if len(splitText) > 1:
        return splitText[1]

def commandFactory(text):
    return partial(commands.get(parseTextCommand(text), noCommand), text=parseTextParams(text))