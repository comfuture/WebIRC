package maroo.net.irc
{
	import adobe.utils.MMEndCommand;
	
	import mx.core.IRawChildrenContainer;

	public class IRCUser extends IRCPrefix
	{
		public var server:IRCServer;
		public var nick:String;
		public var user:String;
		public var host:String;
		public var channels:Vector.<IRCChannel>;
		public var isOper:Boolean = false;
		public var isVoice:Boolean = false;

		public function get isMe():Boolean
		{
			return false;
		}

		public function IRCUser(nick:String, user:String=null, host:String=null)
		{
			super(USER);
			channels = new Vector.<IRCChannel>();
			var match:Array = nick.match(/^([@\+])/);
			if (match) {
				this.nick = nick.substr(1);
				isOper = match[1] == '@';
				isVoice = match[1] == '+';
			} else {
				this.nick = nick;
			}
			this.name = nick;
			this.user = user;
			this.host = host;
		}

		override public function toString():String
		{
			return nick + (user ? '!' + user : '') + (host ? '@' + host : '');
		}
	}
}