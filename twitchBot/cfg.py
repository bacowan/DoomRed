import configparser

config = configparser.RawConfigParser()
config.read('cfg.cfg')

HOST = config.get('twitch', 'HOST')
PORT = config.getint('twitch', 'PORT')
NICK = config.get('twitch', 'NICK')
PASS = config.get('twitch', 'PASS')
CHAN = config.get('twitch', 'CHAN')
DEFAULT_USER_LIMIT = config.getint('bot', 'DEFAULT_USER_LIMIT')
DEFAULT_ALLOW_REPEATS = config.getboolean('bot', 'DEFAULT_ALLOW_REPEATS')
HELP_COOLDOWN_SECONDS = config.getint('bot', 'HELP_COOLDOWN_SECONDS')