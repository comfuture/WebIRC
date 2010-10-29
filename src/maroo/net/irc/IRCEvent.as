package maroo.net.irc
{
	import flash.events.Event;
	
	public class IRCEvent extends Event
	{
		public static const MESSAGE:String = 'message';

		private var _message:IRCMessage;
		public function get message():IRCMessage { return _message; }

		public function IRCEvent(type:String, message:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._message = message;
		}
	}
}