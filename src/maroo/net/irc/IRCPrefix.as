package maroo.net.irc
{
	public class IRCPrefix
	{
		public static const SERVER:String = 'server';
		public static const CHANNEL:String = 'channel';
		public static const USER:String = 'user';

		public var type:String;
		public var name:String;
		
		public function IRCPrefix(type:String)
		{
			this.name = '-';
			this.type = type;
		}
		
		public static function fromString(str:String):IRCPrefix
		{
			if (str.match(/^[&#+!][^\s\,]+&/))
				return IRCChannel(str);
			var match:Array = str.match(/^([^!@]+)(?:(?:\!([^@]+))?(?:\@(\S+)))?$/);
			if (match)
				return new IRCUser(match[1], match[2], match[3]);
			return IRCServer(str);
		}
		
		public function toString():String
		{
			return name;
		}
	}
}