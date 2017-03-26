class AllowRepeats:

    def __init__(self, allow):
        self.allow = allow

    def validate(self, jsonPokemon, queue):
        if self.allow: return False, None

        for queueItem in list(queue.queue):
            if (jsonPokemon['Name'] == queueItem[0]['Name']):
                return True, "This emote is already in the queue. The streamer can allow repeat emotes by typing !toggleRepeats"

        return False, None

class UserLimit:

    def __init__(self, limit):
        self.limit = limit

    def validate(self, jsonPokemon, queue):
        if self.limit == 0: return False, None

        userCount = 0
        for queueItem in list(queue.queue):
            if (jsonPokemon['Username'] == queueItem[0]['Username']):
                userCount += 1
        if userCount >= self.limit:
            return True, "You already have " + str(userCount) + " emotes in queue. The streamer can change the max number of Pokemon per User by typing !setUserLimit limit"
        return False, None
