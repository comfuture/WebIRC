package maroo.net.irc
{
	public class IRCChannel extends IRCPrefix
	{
		public var isSecret:Boolean;
		public var isPrivate:Boolean;
		public var userver:IRCServer;
		public var users:Vector.<IRCUser>;

		public function IRCChannel(name:String, isSecret:Boolean=false, isPrivate:Boolean=false)
		{
			super(CHANNEL);
			this.name = name;
			this.isSecret = isSecret;
			this.isPrivate = isPrivate;
			users = new Vector.<IRCUser>();
		}
		
		public function addUser(user:IRCUser):void
		{
			if (users.indexOf(user) < 0)
				users.push(user);
		}
		
		public function removeUser(user:IRCUser):void
		{
			var pos:int = users.indexOf(user);
			if (pos > -1)
				users.splice(pos, 1);
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
	}
}