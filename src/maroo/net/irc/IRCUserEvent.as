package maroo.net.irc
{
	public class IRCUserEvent extends IRCEvent
	{
		public static const PRIVMSG:String = 'privmsg';
		public static const ACTION:String = 'action';
		public static const NOTICE:String = 'notice';
		public static const NICK:String = 'nick';
		public static const MODE:String = 'mode';
		public static const QUIT:String = 'quit';

		private var _user:IRCUser;
		public function get user():IRCUser { return _user; }

		private var _channel:IRCChannel;
		public function get channel():IRCChannel { return _channel; }
		
		private var _mode:String;
		public function get mode():String { return _mode; }

		public function IRCUserEvent(type:String, message:IRCMessage, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, message, bubbles, cancelable);
			switch (type) {
				case PRIVMSG: case ACTION: case NOTICE:
					_user = message.prefix as IRCUser;
					if (message.params[0].match(/^[&#+!]\S+/))
						_channel = new IRCChannel(message.params[0]);
					break;
				case NICK:
					_user = message.prefix as IRCUser;
					break;
				case MODE:
					_user = message.prefix as IRCUser;
					_mode = message.text;
					break;
				case QUIT:
					_user = message.prefix as IRCUser;
			}
		}
	}
}