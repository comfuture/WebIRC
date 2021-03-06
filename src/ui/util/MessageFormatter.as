package ui.util
{
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.operations.FlowElementOperation;
	
	import maroo.net.irc.IRCMessage;
	
	import spark.utils.TextFlowUtil;

	public class MessageFormatter
	{
		public static function formatMessage(message:IRCMessage):FlowElement
		{
			var p:ParagraphElement;
			switch (message.command) {
				case 'PRIVMSG':
					p = new ParagraphElement();
					/*
					var tpl:XML = <TextFlow xmlns="http://ns.adobe.com/textlayout/2008">
						<p><span>&lt;{message.prefix.name}&gt;</span>
						<span>{message.text}</span></p>
					</TextFlow>;
					var tf:TextFlow = TextFlowUtil.importFromXML(tpl);
					return tf.getChildAt(0);
					*/
					var nick:SpanElement = new SpanElement();
					nick.text = '<' + message.prefix.name + '> ';
					var msg:SpanElement = new SpanElement();
					msg.text = message.text;
					p.addChild(nick);
					p.addChild(msg);
					return p;
				default:
					p = new ParagraphElement();
					var span:SpanElement = new SpanElement();
					span.text = message.toString();
					p.addChild(span);
					return p;

			}
			
			return new ParagraphElement();
		}
		
		public static function formatString(text:String):FlowElement
		{
			var p:ParagraphElement = new ParagraphElement();
			var span:SpanElement = new SpanElement();
			span.text = text;
			p.addChild(span);
			return p;
		}
	}
}