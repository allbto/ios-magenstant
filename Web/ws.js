
var WSApplication = function()
{   var self = this;

    self.ws = new WebSocket("ws://localhost:5050/ws");

    self.ws.onmessage = function(event) {
        console.log("Socket message", event);
        var data = JSON.parse(event.data); 
    };

    self.ws.onclose = function() {
        console.log("Socket closed");
    };

    self.ws.onopen = function() {
        console.log("Connected");
        self.ws.send(JSON.stringify({
            'msg_type' : 'connection',
            'username' : 'tutu'
        }));
    };

    self.send = function(message)
    {
        self.ws.send(JSON.stringify({
            'msg_type' : 'message',
            'content' : message
        }));
    };

    self.onmessage = function(data) {};
};
