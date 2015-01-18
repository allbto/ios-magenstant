
import json

from geventwebsocket import WebSocketApplication
# from models import *

class WSApplication(WebSocketApplication):
    def on_open(self):
        return
        print "Some client connected!"

    def on_message(self, message):
        if message is None:
            return

        print "Message : " + message
        message = json.loads(message)

        if message['msg_type'] == 'connection':
            self.registerClient(message)
        elif message['msg_type'] == 'message':
            self.sendMessage(message)

    def registerClient(self, message):
        current_client = self.ws.handler.active_client
        current_client.nickname = message['username']
        self.send_client_list(message)

    def send_client_list(self, message):
        current_client = self.ws.handler.active_client

        message = json.dumps({
            'msg_type': 'update_clients',
            'clients': [
                getattr(client, 'nickname', 'anonymous')
                for client in self.ws.handler.server.clients.values()
            ]
        })
        self.broadcast(message)

    def broadcast(self, message):
        for client in self.ws.handler.server.clients.values():
            client.ws.send(message)

    def sendMessage(self, message):
        current_client = self.ws.handler.active_client

        for client in self.ws.handler.server.clients.values():
            if client.nickname == message['username']:
                client.ws.send(json.dumps({
                    'msg_type': 'message',
                    'from' : current_client.nickname,
                    'content' : message['content']
                }))

    def on_close(self, reason):
        return
        print "Connection closed!"
