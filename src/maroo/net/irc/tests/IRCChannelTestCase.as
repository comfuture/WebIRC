package maroo.net.irc.tests
{
	import flexunit.framework.Assert;
	
	import maroo.net.irc.IRCChannel;
	import maroo.net.irc.IRCUser;

	public class IRCChannelTestCase
	{
		private var channel:IRCChannel;

		[Before]
		public function setUp():void
		{
			channel = new IRCChannel('#test');
		}
		
		[After]
		public function tearDown():void
		{
			channel = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testAddUser():void
		{
			channel.addUser(new IRCUser('testnick'));
			Assert.assertEquals(channel.users.length, 1);
			channel.addUser(new IRCUser('testnick2'));
			Assert.assertEquals(channel.users.length, 2);
			channel.addUser(new IRCUser('testnick1'));
			Assert.assertEquals(channel.users.length, 2);
		}
	}
}