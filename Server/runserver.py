#!/usr/bin/python

# Imports

from metanager import flask_app

from gevent.wsgi import WSGIServer
from werkzeug.debug import DebuggedApplication
from geventwebsocket import WebSocketServer, Resource
from metanager.app.wsapplication import WSApplication

# Http Server

http_server = WebSocketServer(
    ('', 5050),

    Resource({
        '^/socket': WSApplication,
        '^/.*': DebuggedApplication(flask_app)
    }),

    debug=False
)

if __name__ == "__main__":
	# Activate for websocket
    print "Running on 127.0.0.1:5050"
    http_server.serve_forever()

	# Activate for normal use application
	#flask_app.run()
