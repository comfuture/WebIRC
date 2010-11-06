package maroo.net.irc
{
	import mx.core.IRawChildrenContainer;

	public class IRCChannelEvent extends IRCEvent
	{
		public static const JOIN:String = 'join';
		public static const PART:String = 'part';
		public static const INVITE:String = 'invite';
		public static const KICK:String = 'kick';
		public static const MODE:String = 'mode';

		public static const OP:String = 'channelOp';
		public static const DEOP:String = 'channelDeOp';
		public static const VOICE:String = 'channelVoice';
		public static const DEVOICE:String = 'channelDeVoice';
		public static const BAN:String = 'channelBan';
		public static const UNBAN:String = 'channelUnBan';

		private var _channel:IRCChannel;
		public function get channel():IRCChannel { return _channel; }

		private var _fromUser:IRCUser;
		public function get fromUser():IRCUser { return _fromUser; }

		private var _toUser:IRCUser;
		public function get toUser():IRCUser { return _toUser; }

		private var _mode:String;
		public function get mode():String { return _mode; }

		public function IRCChannelEvent(type:String, message:IRCMessage=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, message, bubbles, cancelable);
			switch (type) {
				case JOIN:
					_channel = message.connection.findChannel(message.params[1]);
					_toUser = message.prefix as IRCUser;
					break;
				case PART:
					_channel = message.connection.findChannel(message.params[0]);
					_toUser = message.prefix as IRCUser;
					break;
				case INVITE: case KICK:
					_channel = message.connection.findChannel(message.params[1]);
					_toUser = message.connection.findUser(message.params[0]);
					_fromUser = message.prefix as IRCUser;
					break;
				// XXX: these are non standard irc message
				case OP: case DEOP: case VOICE: case DEVOICE:
					_channel = message.prefix as IRCChannel;
					_toUser = _channel.findUser(message.params[0]);
					break;
				case MODE:
					_channel = message.connection.findChannel(message.params.shift());
					_mode = message.params.join(' ');
					break;
			}
		}
	}
}