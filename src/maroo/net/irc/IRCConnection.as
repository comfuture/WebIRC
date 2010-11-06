package maroo.net.irc
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class IRCConnection extends Socket
	{
		public var server:IRCServer;
		public var options:Dictionary;
		public var channels:Vector.<IRCChannel>;
		public var users:Vector.<IRCUser>;
		public var me:IRCUser;
		private var buffer:String;

		public function IRCConnection(host:String=null, port:int=6667)
		{
			super(host, port);
			options = new Dictionary();
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
			flush();
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
			chan = new IRCChannel(name);
			chan.connection = this;
			return chan;
		}
		
		/**
		 * Returns first mask-matched user in current connection
		 * or make one
		 * 
		 * @param mask: irc prefix mask pattern or just nickname (can include wildcard chars)
		 * @return new or exist IRCUser
		 */
		public function findUser(mask:String):IRCUser
		{
			// nick
			// @nick
			// +nick
			// nick!user
			// nick!user@host
			// nick@host
			for each (var _user:IRCUser in users) {
				if (IRCUtil.matchMask(_user.mask, mask))
					return _user;
			}
			var match:Array = mask.match(IRCUtil.RE_MASK);
			_user = new IRCUser(match['nick'], match['user'], match['host'], server);
			users.push(_user);
			return _user;
		}
		
		public function findNick(nick:String):IRCUser
		{
			for each (var _user:IRCUser in users) {
				if (_user.nick == nick)
					return _user;
			}
			return findUser(nick);
		}
		
		public function findUsers(mask:String):Vector.<IRCUser>
		{
			var found:Vector.<IRCUser> = users.filter(function(item:*, index:int, arr:Vector.<IRCUser>):Boolean {
				var user:IRCUser = item as IRCUser;
				return IRCUtil.matchMask(item.mask, mask);
			});
			return found;
		}

		private function addUser(user:IRCUser):void
		{
			if (users.indexOf(user) < 0)
				users.push(user);
		}
		
		private function removeUser(user:IRCUser):void
		{
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
			var chanEvent:IRCChannelEvent;
			var userEvent:IRCUserEvent;
			switch (message.command) {
				case '001':	// RPL_WELCOME
					me = findUser(message.text.split(/\s+/).pop());
					break;
				case '005':	// RPL_BOUNCE
					message.params.pop();	// :are supported by this server
					message.params.shift();	// target nick
					for each (var opt:String in message.params) {
						var posEqual:int = opt.indexOf('=');
						if (posEqual > -1) {
							options[opt.substr(0, posEqual)] = opt.substr(posEqual + 1);
						} else {
							options[opt] = true;
						}
					}
					break;
				case 'JOIN':	// join
					chan = findChannel(message.params[1]);
					if (channels.indexOf(chan) < 0)
						channels.push(chan);
					chanEvent = new IRCChannelEvent(IRCChannelEvent.JOIN, message);
					dispatchEvent(chanEvent);
					break;
				case 'PART':
					chan = findChannel(message.params[1]);
					if (channels.indexOf(chan) > -1)
						channels.splice(channels.indexOf(chan), 1);
					chanEvent = new IRCChannelEvent(IRCChannelEvent.PART, message);
					dispatchEvent(chanEvent);
					break;
				case '353':	// users
					chan = findChannel(message.params[2]);
					if (chan) {
						if (message.params[1] == '@')
							chan.setMode('+s');
						if (message.params[1] == '*')
							chan.setMode('+p');
						
						var nicks:Array = message.text.split(/\s+/);
						for each (var nick:String in nicks) {
							user = new IRCUser(nick); //findNick(nick);
							chan.addUser(user);
						}
					}
					break;
				case '366':	// end of channel info
					break;
				case 'PRIVMSG':
					userEvent = new IRCUserEvent(IRCUserEvent.PRIVMSG, message);
					dispatchEvent(userEvent);
					break;
				case 'MODE':
					if (/^[&#+!]\S+/.test(message.params[0])) { // channel modes
						chan = new IRCChannel(message.params[0]);
						chan.setMode(message.params.join(' '));
						chanEvent = new IRCChannelEvent(IRCChannelEvent.MODE, message);
						dispatchEvent(chanEvent);
					} else {	// user mode
						user = new IRCUser(message.params[0]);
						user.setMode(message.params.join(' '));
						userEvent = new IRCUserEvent(IRCUserEvent.MODE, message);
						dispatchEvent(userEvent);
					}
					break;
				case 'QUIT':
					user = message.prefix as IRCUser;
					userEvent = new IRCUserEvent(IRCUserEvent.QUIT, message);
					dispatchEvent(userEvent);
					break;
			}
		}
	}
}