package maroo.net.irc
{
	import flash.utils.Dictionary;

	public class IRCChannel extends IRCPrefix
	{
		public var isSecret:Boolean;
		public var isPrivate:Boolean;
		public var modes:Array;
		public var key:String;
		public var limit:int = -1;
		public var users:Vector.<IRCUser>;
		public var opers:Vector.<IRCUser>;
		public var voices:Vector.<IRCUser>;
		public var bans:Vector.<IRCUser>;

		public function IRCChannel(name:String, isSecret:Boolean=false, isPrivate:Boolean=false)
		{
			super(CHANNEL);
			this.name = name;
			this.isSecret = isSecret;
			this.isPrivate = isPrivate;
			modes = [];
			users = new Vector.<IRCUser>();
		}
		
		public function addUser(user:IRCUser):void
		{
			if (users.indexOf(user) < 0)
				users.push(user);
		}
		
		public function removeUser(user:IRCUser):void
		{
			for each (var container:Vector.<IRCUser> in [users, opers, voices]) {
				var pos:int = container.indexOf(user);
				if (pos > -1)
					container.splice(pos, 1);
			}
		}
		
		private function manageList(jar:Vector.<IRCUser>, snake:IRCUser, effect:String):void
		{
			if (effect == '+') {
				if (jar.indexOf(snake) < 0)
					jar.push(snake);
			} else if (effect == '-') {
				if (jar.indexOf(snake) > -1)
					jar.splice(jar.indexOf(snake), 1);
			}
		}
		
		public function op(user:IRCUser, effect:String='+'):void
		{
			manageList(opers, user, effect);
		}
		
		public function voice(user:IRCUser, effect:String='+'):void
		{
			manageList(voices, user, effect);
		}
		
		public function ban(user:IRCUser, effect:String='+'):void
		{
			manageList(bans, user, effect);
		}
		
		public function setKey(key:String, effect:String='+'):void
		{
			if (effect == '-')
				this.key = '';
			else
				this.key = key;
		}

		public function findUser(mask:String):IRCUser
		{
			var match:Array = mask.match(/^([^!@]+)(?:(?:\!([^@]+))?(?:\@(\S+)))?$/);
			var nick:String = match[1];
			for each (var user:IRCUser in users) {
				if (user.nick == nick)
					return user;
			}
			// XXX: IRCUser.fromString not works
			//return IRCUser.fromString(mask) as IRCUser;
			return new IRCUser(nick);
		}
		
		public function getMode():String
		{
			return '+' + modes.join('');
		}
		
		public function setMode(mode:String):void
		{
			var targets:Array = mode.split(/\s+/);
			mode = targets.shift();
			var _modes:Array = mode.split(/(.)/);
			var effect:String = '+';
			
			var methodMap:Object = {
				'o': op, 'v': voice, 'b': ban, 'k': setKey
			};

			for each (var char:String in _modes) {
				if (char == '+' || char == '-') {
					effect = char;
					continue;
				}
				if (['o','v','b','k'].indexOf(char)) { // op voice ban key
					methodMap[char](targets.shift(), effect);
				} else if (char == 'l') {	// limit
					if (effect == '+')
						limit = int(targets.shift());
					else
						limit = -1;
				} else {	// other channel modes
					if (effect == '+') {
						if (modes.indexOf(char) < 0)
							modes.push(char);
					} else {
						if (modes.indexOf(char) > -1)
							modes.splice(modes.indexOf(char), 1);
					} 
				}
			}
		}
	}
}