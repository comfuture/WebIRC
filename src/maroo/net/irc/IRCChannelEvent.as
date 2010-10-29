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

		private var _channel:IRCChannel;
		public function get channel():IRCChannel { return _channel; }

		public function IRCChannelEvent(type:String, channel:IRCChannel, message:IRCMessage=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, message, bubbles, cancelable);
			_channel = channel;
		}
	}
}