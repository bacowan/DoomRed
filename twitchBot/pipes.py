import win32pipe, win32file

class Pipe:
    def __init__(self, pipeName):
        self.p = win32pipe.CreateNamedPipe(
            pipeName,
            win32pipe.PIPE_ACCESS_OUTBOUND,
            win32pipe.PIPE_TYPE_MESSAGE | win32pipe.PIPE_READMODE_MESSAGE | win32pipe.PIPE_WAIT,
            1,
            1000000,
            1000000,
            50,
            None)
        win32pipe.ConnectNamedPipe(self.p, None)
    
    def __enter__(self):
        return self
    
    def write(self, data):
        win32file.WriteFile(self.p, data)
    
    def __exit__(self, exc_type, exc_value, traceback):
        self.p.close()

if __name__ == "__main__":
    pass