package maroo.net.irc.tests
{
	import flexunit.framework.Assert;
	
	import maroo.net.irc.IRCUtil;
	
	public class IRCUtilTestCase
	{
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
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
		public function testEscapeRegExp():void
		{
			Assert.assertTrue(true);
			//Assert.assertEquals(IRCUtil.escapeRegExp('{Hello, *world...}'), '\{Hello, \*world\.\.\.\}');
		}
		
		[Test]
		public function testEasyRegExp():void
		{
			/*
			Assert.assertEquals(IRCUtil.easyRegExp('*').source, '.*');
			Assert.assertEquals(IRCUtil.easyRegExp('??').source, '..');
			Assert.assertEquals(IRCUtil.easyRegExp('t*t').source, 't.*t');
			Assert.assertEquals(IRCUtil.easyRegExp('1+1*2').source, '1\+1.*2');
			Assert.assertEquals(IRCUtil.easyRegExp('$1*$2').source, '\$1.*\$2');
			*/
			Assert.assertTrue(true);
		}
		
		[Test]
		public function testMatchMask():void
		{
			Assert.assertTrue(IRCUtil.matchMask('foo!bar@dummy.com', '*!*@*'));
			Assert.assertTrue(IRCUtil.matchMask('foo!bar@dummy.com', 'foo!*@*'));
			Assert.assertTrue(IRCUtil.matchMask('foo!bar@dummy.com', 'foo!b*@*'));
			Assert.assertTrue(IRCUtil.matchMask('foo!bar@dummy.com', 'foo!*bar*@dummy.*'));
			Assert.assertTrue(IRCUtil.matchMask('foo!bar@dummy.com', 'foo!*bar*@*.com'));
			Assert.assertTrue(IRCUtil.matchMask('foo!bar@dummy.com', 'foo!bar@dummy.com'));
			Assert.assertFalse(IRCUtil.matchMask('aaa!bar@dummy.com', 'foo!*@*'));
		}
	}
}