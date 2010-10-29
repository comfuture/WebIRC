package maroo.net.irc.scripting
{
	import luaAlchemy.LuaAlchemy;
	
	public class Environment extends LuaAlchemy
	{
		public function Environment(app:WebIRC)
		{
			// XXX: dependency
			super();
			setGlobalLuaValue("stage", app.stage);
			setGlobalLuaValue("conn", app.conn);
		}

		override public function setGlobal(name:String, value:*):void
		{
			setGlobalLuaValue(name, value);
		}
		
		override public function doString(code:String):Array
		{
			// TODO: filter insecure patterns
			if (/= ?as3\./.test(code)) {
				throw new Error("security sandbox error");
				return [];
			}
			return super.doString(code);
		}
	}
}