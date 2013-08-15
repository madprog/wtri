package sys;

import haxe.io.Bytes;
import sys.net.Socket;

@:require(sys)
class WebServer<Client:WebServerClient> extends sys.net.ThreadSocketServer<Client,String> {
	/*
	#if (cpp||neko)
	sys.net.ThreadSocketServer<Client,String>
	//sys.net.SocketServer<Client>
	#elseif java
	sys.net.SocketServer<Client>
	#end {
	*/

	public var host(default,null) : String;
	public var port(default,null) : Int;

	public function new( host : String, port : Int ) {
		super();
		this.host = host;
		this.port = port;
	}

	public function start() {
		run( host, port );
	}

	override function clientConnected( s : Socket ) : Client {
		return throw 'abstract method';
	}

	override function clientDisconnected( c : Client ) {
		c.cleanup();
	}

	override function readClientMessage( c : Client, buf : Bytes, pos : Int, len : Int ) : { data : String, length : Int } {
		var r = c.readRequest( buf, pos, len );
		if( r == null )
			return null;
		c.processRequest( r );
		return { data : null, length : len };
	}

}
