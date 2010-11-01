package maroo.net.irc
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class IRCConnection extends Socket
	{
		public var server:IRCServer;
		public var channels:Vector.<IRCChannel>;
		public var users:Vector.<IRCUser>;
		private var buffer:String;

		public function IRCConnection(host:String=null, port:int=6667)
		{
			super(host, port);
			buffer = '';
			server = new IRCServer(host);
			server.connection = this;
			channels = new Vector.<IRCChannel>();
			users = new Vector.<IRCUser>();

			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			addEventListener(ProgressEvent.SOCKET_DATA, onReceiveBytes);
			addEventListener(IRCEvent.MESSAGE, onMessage);
		}
		
		public function send(str:String):void
		{
			writeUTFBytes(str + '\r\n');
		}
		
		public function sendMessage(message:IRCMessage):void
		{
			send(message.toString());
		}
		
		public function findChannel(name:String):IRCChannel
		{
			for each (var chan:IRCChannel in channels) {
				if (chan.name == name)
					return chan;
			}
			return new IRCChannel(name);
		}
		
		public function findUser(mask:String):IRCUser
		{
			// nick
			// @nick
			// +nick
			// nick!user
			// nick!user@host
			// nick@host
			var match:Array = mask.match(/^(?P<nick>[@\+]?[^!@]+)(?:(?:\!(?P<user>[^@]+))?(?:\@(?P<host>\S+)))?$/);
			var nick:String = match['nick'];
			if (nick.match(/^@\+/)) {
				nick = nick.substr(1);
			}
			var user:String = match['user'];
			var host:String = match['host'];
			for each (var _user:IRCUser in users) {
				if (_user.nick == nick)
					return _user;
			}
			_user = new IRCUser(nick, user, host);
			return _user;
		}
		
		public function findUsers(mask:String):Vector.<IRCUser>
		{
			// TODO: implement this
			return new Vector.<IRCUser>();
		}

		private function addUser(user:IRCUser):void
		{
			if (users.indexOf(user) < 0)
				users.push(user);
		}
		
		private function removeUser(user:IRCUser):void
		{
			for each (var chan:IRCChannel in user.channels) {
				chan.removeUser(user);
			}
			var pos:int = users.indexOf(user);
			if (pos > -1)
				users.splice(pos, 1);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			Alert.show(event.toString());
		}
		
		private function onReceiveBytes(event:ProgressEvent):void
		{
			while (bytesAvailable) {
				var bytes:ByteArray = new ByteArray();
				readBytes(bytes, 0, bytesAvailable);
				bytes.position = 0;
				buffer += bytes.readUTFBytes(bytes.bytesAvailable);
			}
			var eol:int;
			var line:String;
			while (true) {
				eol = buffer.indexOf("\r\n");
				if (eol == -1)
					break;
				line = buffer.substring(0, eol);
				buffer = buffer.substring(eol + 2);
				if (line) {
					if (0 == line.indexOf('PING')) {
						send('PONG' + line.substr(4));
						return;
					}
					var message:IRCMessage = IRCMessage.fromString(line, this);
					var e:IRCEvent = new IRCEvent(IRCEvent.MESSAGE, message);
					dispatchEvent(e);
				}
			}
		}
		
		private function onMessage(event:IRCEvent):void
		{
			var message:IRCMessage = event.message;
			var chan:IRCChannel;
			var user:IRCUser;
			switch (message.command) {
				case 'JOIN':	// join
					chan = findChannel(message.params[1]);
					if (channels.indexOf(chan) < 0)
						channels.push(chan);
					//MonsterDebugger.trace(this, message);
					break;
				case '353':	// users
					chan = findChannel(message.params[2]);
					if (chan) {
						if (message.params[1] == '@')
							chan.isSecret = true;
						if (message.params[1] == '*')
							chan.isPrivate = true;
						
						var nicks:Array = message.text.split(/\s+/);
						for each (var nick:String in nicks) {
							if (nick.match(/^[@\+]/)) {
								nick = nick.substr(1);
								chan.setMode('+o ' + nick);
							}
							user = findUser(nick);
							if (user.channels.indexOf(chan) < 0)
								user.channels.push(chan);
							if (users.indexOf(user) < 0)
								users.push(user);
							if (chan.users.indexOf(user) < 0)
								chan.users.push(user);
						}
					}
					break;
				case '366':	// end of channel info
					break;
				case 'MODE':
					if (/^[&#+!][^\s\,]+&/.test(message.params[0])) { // channel modes
						chan = findChannel(message.params.pop());
						chan.setMode(message.params.join(' '));
					} else {	// user mode
						user = findUser(message.params.pop());
						user.setMode(message.params.join(' '));
					}
					break;
				case 'QUIT':
					user = message.prefix as IRCUser;
					removeUser(user);
					break;
			}
		}
	}
}