package maroo.net.irc
{
	import com.bealearts.collection.VectorCollection;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class IRCUserCollection extends VectorCollection
	{
		public function IRCUserCollection(source:Object)
		{
			super(source);
			var sort:Sort = new Sort();
			var opSortField:SortField = new SortField('isOper');
			var voiceSortField:SortField = new SortField('isVoice');
			var nickSortField:SortField = new SortField('nick', true);
			sort.fields = [nickSortField];
			this.sort = sort;
		}
		
		override public function contains(item:Object):Boolean
		{
			for each (var user:IRCUser in this) {
				if (user.nick == (item as IRCUser).nick)
					return true;
			}
			return false;
		}
		
		override public function getItemIndex(item:Object):int
		{
			for (var i:int = 0; i < length; i++) {
				if ((getItemAt(i) as IRCUser).nick == (item as IRCUser).nick)
					return i;
			}
			return -1;
		}
		
		public function addUser(user:IRCUser):void
		{
			if (contains(user)) {
				updateUser(user);
			} else {
				addItem(user);
			}
		}
		
		public function removeUser(user:IRCUser):void
		{
			var index:int = getItemIndex(user);
			if (index > -1)
				removeItemAt(index);
		}
		
		public function updateUser(user:IRCUser):void
		{
			for each (var _user:IRCUser in this) {
				if (user.nick == _user.nick) {
					_user.host = user.host || _user.host;
					_user.user = user.user || _user.user;
					_user.isOper = user.isOper || _user.isOper;
					_user.isVoice = user.isVoice || _user.isVoice;
					itemUpdated(_user);
				}
			}
		}
	}
}