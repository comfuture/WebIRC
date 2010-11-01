package maroo.net.irc
{
	import adobe.utils.MMEndCommand;
	
	import flash.utils.Dictionary;
	
	import mx.core.IRawChildrenContainer;

	public class IRCUser extends IRCPrefix
	{
		public var nick:String;
		public var user:String;
		public var host:String;
		public var channels:Vector.<IRCChannel>;
		public var modes:Array;

		public function get isMe():Boolean
		{
			return false;
		}
		
		public function get mask():String { return toString(); }

		public function IRCUser(nick:String, user:String=null, host:String=null)
		{
			super(USER);
			channels = new Vector.<IRCChannel>();
			modes = [];
			/*
			var match:Array = nick.match(/^([@\+])/);
			if (match) {
				this.nick = nick.substr(1);
				isOper = match[1] == '@';
				isVoice = match[1] == '+';
			} else {
				this.nick = nick;
			}
			*/
			this.nick = nick;
			this.name = nick;
			this.user = user;
			this.host = host;
		}
		
		public function setMode(mode:String):void
		{
			var effect:String = '+';
			var _modes:Array = mode.split(/./);
			for each (var char:String in _modes) {
				if (char == '+' || char == '-') {
					effect = char;
					continue;
				}
				if (effect == '+') {
					if (modes.indexOf(char) < 0)
						modes.push(char);
				} else {
					if (modes.indexOf(char) > -1)
						modes.splice(modes.indexOf(char), 1);
				}
			}
		}
		
		public function getMode(chan:IRCChannel):String
		{
			return '+' + modes.join('');
		}
		
		public function isOper(chan:IRCChannel):Boolean
		{
			// TODO: implement this
			return false;
		}

		public function isVoice(chan:IRCChannel):Boolean
		{
			// TODO: implement this
			return false;
		}

		override public function toString():String
		{
			return nick + (user ? '!' + user : '') + (host ? '@' + host : '');
		}
	}
}