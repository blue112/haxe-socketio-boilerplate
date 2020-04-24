import js.node.socketio.Client;
import Protocol;

class Client
{
    static var client:js.node.socketio.Client;

    static public function debug(value:Dynamic, ?pos:haxe.PosInfos)
    {
        var debugZone = js.Browser.document.getElementById("debug");

        var debugLine = js.Browser.document.createSpanElement();
        debugLine.innerHTML = '[${pos.fileName}:${pos.lineNumber}] $value<br />';

        debugZone.append(debugLine);
    }

    static public function main()
    {
        haxe.Log.trace = debug;
        client = new js.node.socketio.Client("http://localhost:8001/");

        client.on('connect', () ->
        {
            trace("Connected !");
            send(LOGIN);
        });
        client.on('disconnect', () ->
        {
            trace("Disconnected");
        });
        client.on('message', (data) ->
        {
            var message:ServerMessage = haxe.Unserializer.run(data);
            handle(message);
        });
    }

    static public function send(message:ClientMessage)
    {
        client.emit("message", haxe.Serializer.run(message));
        trace('>> $message');
    }

    static public function handle(message:ServerMessage)
    {
        trace('<< $message');
    }
}
