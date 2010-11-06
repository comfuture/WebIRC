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
		public var isOper:Boolean;
		public var isVoice:Boolean;
		public var isMe:Boolean;
		public var modes:Array;
		
		public function get mask():String { return toString(); }

		public function IRCUser(nick:String, user:String=null, host:String=null, server:IRCServer=null)
		{
			super(USER);
			modes = [];
			var match:Array = nick.match(/^(?P<mode>[@\+]*)(?P<rawnick>\S+)/);
			if (match['mode']) {
				isOper = match['mode'].indexOf('@') > -1;
				isVoice = match['mode'].indexOf('+') > -1;
			}
			this.nick = match['rawnick'];
			this.name = nick;
			this.user = user;
			this.host = host;
		}
		
		/*
		public static function fromMask(mask:String):IRCUser
		{
			return new IRCUser(mask);
		}
		*/
		
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

		override public function toString():String
		{
			return nick + (user ? '!' + user : '!*') + (host ? '@' + host : '@*');
		}
	}
}