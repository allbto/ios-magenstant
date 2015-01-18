from werkzeug.debug import DebuggedApplication
from geventwebsocket import WebSocketServer, Resource

from wsapplication import WSApplication

ip = '127.0.0.1'
port = 5050

http_server = WebSocketServer(
    (ip, port),

    Resource({
        '^/ws': WSApplication
    }),

    debug=False
)

if __name__ == "__main__":
    print "Running on "+ ip +":"+str(port)
    http_server.serve_forever()
