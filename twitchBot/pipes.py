#import win32pipe, win32file
from ctypes import *
from time import sleep

# See msdn for these constants
PIPE_ACCESS_OUTBOUND = 2
PIPE_TYPE_MESSAGE = 4
PIPE_READMODE_MESSAGE = 2
PIPE_WAIT = 0

class Pipe:
    def __init__(self, pipeName):
        self.p = windll.kernel32.CreateNamedPipeW(
            pipeName,
            PIPE_ACCESS_OUTBOUND,
            PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,
            1,
            1000000,
            1000000,
            50,
            None)
        windll.kernel32.ConnectNamedPipe(self.p, None)
    
    def __enter__(self):
        return self
    
    def write(self, data):
        cbWritten = c_ulong(0)
        windll.kernel32.WriteFile(self.p, data, len(data), byref(cbWritten), None)
    
    def __exit__(self, exc_type, exc_value, traceback):
        windll.kernel32.CloseHandle(self.p)