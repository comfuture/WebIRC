package maroo.net.irc
{
	public class IRCServer extends IRCPrefix
	{
		public function IRCServer(name:String)
		{
			super(SERVER);
			this.name = name;
		}
	}
}