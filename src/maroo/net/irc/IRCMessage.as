package maroo.net.irc
{
	import mx.utils.StringUtil;

	public class IRCMessage
	{
		public var connection:IRCConnection;
		public var command:String;
		public var prefix:IRCPrefix;
		public var params:Array;
		public function get target():String { return params.length > 0 ? params[0] : null; }
		public function get text():String { return params.length > 0 ? params[params.length - 1] : ''; }
		public var raw:String;
		
		public function IRCMessage(command:String, prefix:*=null, params:Array=null)
		{
			this.command = command;
			if (prefix is IRCPrefix)
				this.prefix = prefix;
			else if (prefix is String)
				this.prefix = IRCPrefix.fromString(prefix);
			this.params = params || [];
		}
		
		public static function fromString(str:String, conn:IRCConnection=null):IRCMessage
		{
			var re:RegExp = new RegExp("^(?:[:@](?P<prefix>[^\\s]+) )?" +
				"(?P<command>[^\\s]+)" +
				"(?: (?P<params>(?:[^:\\s][^\\s]* ?)*))?" +
				"(?: ?:(?P<text>.*))?$");
			var match:Array = str.match(re);
			if (!match)
				throw new Error('Invalid Message format');
			var prefix:IRCPrefix = IRCPrefix.fromString(match['prefix'], conn);
			var cmd:String = StringUtil.trim(match['command']);
			var params:Array = StringUtil.trim(match['params']).split(/\s+/);
			if (match['text'])
				params.push(StringUtil.trim(match['text']));
			var message:IRCMessage = new IRCMessage(cmd, prefix, params);
			message.connection = conn;
			message.raw = str;
			return message;
		}

		public function toString():String
		{
			var paramText:String = '';
			if (params.length > 0) {
				var lastParam:String = params.pop();
				paramText = params.join(' ') + ' :' + lastParam;
			}
			return (prefix ? ':' + prefix.toString() + ' ' : '') + 
				command + (paramText ? ' ' + paramText : '');
				
		}
	}
}