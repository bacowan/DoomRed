import cfg
import libs
import command
import pipes
import socket
import re
from threading import Thread
from queue import Queue
from queue import Empty
from time import sleep

PING_REQUEST = "PING :tmi.twitch.tv\r\n"
PING_RESPONSE = "PONG :tmi.twitch.tv\r\n"
SEND_RATE = float(2)/float(3)
CHAT_MSG = re.compile(r"^:\w+!\w+@\w+\.tmi\.twitch\.tv PRIVMSG #\w+ :")
EMPTY_TEXT = "0"

def connect():
    s = socket.socket()
    s.connect((cfg.HOST, cfg.PORT))
    s.send("PASS {}\r\n".format(cfg.PASS).encode("utf-8"))
    s.send("NICK {}\r\n".format(cfg.NICK).encode("utf-8"))
    s.send("JOIN {}\r\n".format(cfg.CHAN).encode("utf-8"))
    return s

def sendPingResponse(sock):
    sock.send(PING_RESPONSE.encode("utf-8"))

def handleChatInput(sock, input, queue):
    try:
        username = re.search(r"\w+", input).group(0)
        message = CHAT_MSG.sub("", input).strip()
        print (username + ":-" + message + "-")
        com = command.commandFactory(message)
        startCommandThread(com, (username, sock, queue))        
    except:
        libs.chat(sock, "Stop trying to break me BibleThump")
        return

def startCommandThread(com, arg):
    Thread(target=com, args=arg).start()

def processChat(sock, queue):
    while True:
        response = sock.recv(1024).decode("utf-8")
        if response == PING_REQUEST:
            sendPingResponse(sock)
        else:
            handleChatInput(sock, response, queue)
        sleep(1/SEND_RATE)

def luaWriter(queue):
    while True:
        with pipes.Pipe('\\\\.\\pipe\\doomred') as pipe:
            try:
                text = queue.get(block=False)[1]
            except Empty:
                text = EMPTY_TEXT
            pipe.write(text)

def startPipeThread(q):
    Thread(target=luaWriter, args=(q,)).start()

def main():
    q = Queue()
    startPipeThread(q)
    sock = connect()
    processChat(sock, q)

if __name__=="__main__":
    main()