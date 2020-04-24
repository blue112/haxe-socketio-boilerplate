import js.node.socketio.Socket;
import Protocol;

class Server
{
    static public function main()
    {
        var expressServer = new express.Express();
        var httpServer = js.node.Http.createServer(cast expressServer);
        var server = new js.node.socketio.Server({transports: ["websocket"]});
        server.origins('http://0.0.0.0:8000');

        server.listen(httpServer);
        httpServer.listen(8001);
        trace("Listening on port 8001");

        server.on(
            'connection',
            function(socket:Socket)
            {
                socket.on('message', function (data)
                {
                    try
                    {
                        handle(socket, haxe.Unserializer.run(data));
                    }
                    catch (e:Dynamic)
                    {
                        trace("Unable to handle message");
                        trace(data);
                    }
                });
            }
        );
    }

    static public function send(to:Socket, message:ServerMessage)
    {
        to.emit("message", haxe.Serializer.run(message));
    }

    static public function handle(from:Socket, message:ClientMessage)
    {
        switch (message)
        {
            case LOGIN:
                send(from, HELLO);
        }
    }
}
