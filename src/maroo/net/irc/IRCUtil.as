package maroo.net.irc
{
	public class IRCUtil
	{
		public static const RE_MASK:RegExp = /^[@\+]*(?P<nick>[^!@]+)(?:(?:\!(?P<user>[^@]+))?(?:\@(?P<host>\S+)))?$/;
		public static function escapeRegExp(pattern:String):String
		{
			return pattern.replace(
				new RegExp("([{}\(\)\^$&.\*\?\/\+\|\[\\\\]|\]|\-)","g"),
				"\\$1");
		}
		
		public static function easyRegExp(wildcard:String, modifier:String=null):RegExp
		{
			var s:String = '';
			for each (var char:String in wildcard.split('')) {
				if (char == '*')
					s += '.*';
				else if (char == '?')
					s += '.';
				else
					s += escapeRegExp(char);
			}
			var re:RegExp = new RegExp(s, modifier);
			return re;
		}
		
		public static function matchMask(target:String, mask:String):Boolean
		{
			var match:Array = mask.match(RE_MASK);
			var nick:String = match['nick'];
			var user:String = match['user'] || '*';
			var host:String = match['host'] || '*';
			if (mask.match(/^[@\+]+[^!@]+$/)) {
				nick = nick.substr(1);
			}
			mask = nick + '!' + user + '@' + host; 
			var re:RegExp = easyRegExp(mask, 'i');
			return re.test(target);
		}
	}
}