# DoomRed
Pokemon FireRed rom hack that introduces twitch integration: viewers create their own pokemon which are encountered in game, live.

# Setup Instructions
1. Download this repo as a zip
2. Download [python 3](https://www.python.org/downloads/) (make sure to check the option "add to system variables")
3. set up config file:
  1. Log into your bot's account (if you don't have an account for your bot, you can either create one or just use your own account).
  2. Generate an [OAuth token](http://twitchapps.com/tmi/) for your bot
  3. Open DoomRed\twitchBot\cfg.cfg
  4. Change the value of NICK to your bot's name (in lowercase)
  5. Change the value of PASS to the OAuth token that was generated (including "oauth:")
  6. Change the value of CHAN to "#" followed by the channel you wish to join (in lowercase). For example, if you wish to join the channel "TwitchChannel", you would change this value to "#twitchchannel"
4. Run DoomRed\setupBot.bat (double click on it)
5. Download [VBA-RR](http://tasvideos.org/EmulatorResources/VBA.html)
6. Obtain a ROM of Pokemon FireRed US V1.1

# Updating Emotes
The mappings from emotes to urls are cached. If you want new emotes to appear in game, you have to update the cache. To do so run the following for Twitch emotes and FFZ emotes, respectively (double click on them):
- DoomRed/updateTwitchEmotes.bat
- DoomRed/updateFFZ.bat

# Other Configurations
In DoomRed\twitchBot\cfg.cfg there are other configurations that can be set related to the gameplay itself:
- DEFAULT_USER_LIMIT: this the the maximum number of pokemon that a user can have queued at any given time. Set to 0 for no limit.
- DEFAULT_ALLOW_REPEATS: this tells the game whether or not multiple of the same emote can be queued at the same time.
- HELP_COOLDOWN_SECONDS: the cooldown time for the help command in seconds (if multiple help commands are given within this time frame, the latter responses will not be displayed)

# How to Play
## How to Run the Game
1. Run DoomRed\runBot.bat (double click on it)
2. Run VBA-RR and load the ROM
3. Click Tools -> Lua Scripting -> New Lua Script Window...
4. In the new window that pops up, click Browse...
5. Open DoomRed\lua\DoomRed.lua
6. Click Run

## Once in Game
### Playing
- Each Pokemon that is encountered (wild or during a trainer battle) will be created using from the commands that chat gives (described below). The Pokemon are entered into a queue as they are entered.

### Commands
- The following commands will add a Pokemon to the queue that looks like the given emote. The options with "type" will give the pokemon that type (case insensitive). Most other stats of the Pokemon are random:
  - !pokemon [emote]
  - !pokemon [emote] [type1]
  - !pokemon [emote] [type1] [type2]

- The following command gives a brief explaination of how to play:
  - !help

- The following commands are streamer only configuration commands:
  - !setUserLimit [number]
    - Sets the value of USER_LIMIT (explained above)
  - !toggleRepeats
    - Flips the value of ALLOW_REPEATS (explained above)

### Gotchas
This game is still in a beta phase, so there are a number of improvements to be made. The comprehensive list of known issues is listed under Issues, but here are some important ones to be aware of:
- Gifted Pokemon have not been implemented. That means that your first Pokemon will be a regular Pokemon. It will actually change species after a while.
- The game will crash after meeting a large number of Pokemon. I am unsure how many, but the first time it crashed on me was after playing for 8 straight hours.

# Troubleshooting
- If double clicking on any of the python scripts doesn't work, try the following:
  - Open a command prompt (type "cmd" into the start menu and click enter)
  - type the following into the command prompt and hit enter:
    - cd "path/to/script"
  - type the following into the command prompt and hit enter:
    - python name_of_script.py
- To check if you have the correct version of python running:
  - type the following into a command prompt:
    - python -V
  - the output should say:
    - Python 3.6.0
