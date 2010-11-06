package maroo.net.irc
{
	import flash.utils.Dictionary;

	public class IRCChannel extends IRCPrefix
	{
		public var modes:Array;
		public var key:String;
		public var limit:int = -1;
		public var users:Vector.<IRCUser>;
		public var bans:Vector.<String>;

		public function IRCChannel(name:String, mode:String=null)
		{
			super(CHANNEL);
			this.name = name;
			modes = [];
			users = new Vector.<IRCUser>();
			bans = new Vector.<String>();
			if (mode)
				setMode(mode);
		}
		
		public function addUser(user:IRCUser):void
		{
			var exists:Boolean = false;
			for (var i:int = 0, cnt:int = users.length; i < cnt; i++) {
				if (users[i].nick == user.nick) {
					// merge properties
					users[i].host = user.host || users[i].host;
					users[i].user = user.user || users[i].user;
					users[i].isOper = user.isOper || users[i].isOper;
					users[i].isVoice = user.isVoice || users[i].isVoice;
					exists = true;
					return;
				}
			}
			if (!exists)
				users.push(user);
		}
		
		public function removeUser(user:IRCUser):void
		{
			for (var i:int = 0, cnt:int = users.length; i < cnt; i++) {
				if (users[i].nick == user.nick) {
					users.splice(i, 1);
					return;
				}
			}
		}

		public function op(mask:String, effect:String='+'):void
		{
			for each (var user:IRCUser in findUsers(mask)) {
				user.isOper = (effect == '+');
				var type:String = effect == '+' ? IRCChannelEvent.OP : IRCChannelEvent.DEOP;
				var message:IRCMessage = new IRCMessage(type, this, [user.nick]);
				var event:IRCChannelEvent = new IRCChannelEvent(type, message);
				connection.dispatchEvent(event);
			}
		}
		
		public function voice(mask:String, effect:String='+'):void
		{
			for each (var user:IRCUser in findUsers(mask)) {
				user.isVoice = (effect == '+');
				var type:String = effect == '+' ? IRCChannelEvent.VOICE : IRCChannelEvent.DEVOICE;
				var message:IRCMessage = new IRCMessage(type, this, [user.nick]);
				var event:IRCChannelEvent = new IRCChannelEvent(type, message);
				connection.dispatchEvent(event);
			}
		}
		
		public function ban(mask:String, effect:String='+'):void
		{
			for (var i:int = bans.length; i >= 0; i--) {				
				if (IRCUtil.matchMask(bans[i], mask)) {
					bans.splice(i, 1);
				}
			}
			if (effect == '+') {
				bans.push(mask);
			}
		}
		
		public function setKey(key:String, effect:String='+'):void
		{
			if (effect == '-')
				this.key = '';
			else
				this.key = key;
		}

		public function findUser(nick:String):IRCUser
		{
			for each (var user:IRCUser in users) {
				if (user.nick == nick)
					return user;
			}
			return null;
		}
		
		public function findUsers(mask:String):Vector.<IRCUser>
		{
			var found:Vector.<IRCUser> = users.filter(function(item:*, index:int, arr:Vector.<IRCUser>):Boolean {
				var user:IRCUser = item as IRCUser;
				return IRCUtil.matchMask(item.mask, mask);
			});
			return found;
		}
		
		public function getMode():String
		{
			return '+' + modes.join('');
		}
		
		public function setMode(mode:String):void
		{
			var targets:Array = mode.split(/\s+/);
			var options:String = targets.shift();
			var opt:Array = options.split('');
			var effect:String = '+';
			
			var methodMap:Object = {
				'o': op, 'v': voice, 'b': ban, 'k': setKey
			};

			for each (var char:String in opt) {
				if (char == '+' || char == '-') {
					effect = char;
					continue;
				}
				if (['o','v','b','k'].indexOf(char) > -1) { // op voice ban key
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
			if (targets.length > 0)
				setMode(targets.join(' '));
		}
	}
}