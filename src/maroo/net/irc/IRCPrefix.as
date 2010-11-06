package maroo.net.irc
{
	import flash.events.EventDispatcher;

	public class IRCPrefix extends EventDispatcher
	{
		public static const SERVER:String = 'server';
		public static const CHANNEL:String = 'channel';
		public static const USER:String = 'user';

		public var connection:IRCConnection;
		public var type:String;
		public var name:String;
		
		public function IRCPrefix(type:String)
		{
			super(this);
			this.name = '-';
			this.type = type;
		}
		
		public static function fromString(str:String, conn:IRCConnection=null):IRCPrefix
		{
			if (str.match(/^[&#+!][^\s\,]+&/)) {
				if (conn)
					return conn.findChannel(str);
				return new IRCChannel(str);
			}
			var match:Array = str.match(/^([^!@]+)(?:(?:\!([^@]+))(?:\@(\S+)))$/);
			if (match) {
				if (conn)
					return conn.findUser(str);
				return new IRCUser(match[1], match[2], match[3]);
			}
			return new IRCServer(str); // XXX
		}
		
		override public function toString():String
		{
			return name;
		}
	}
}