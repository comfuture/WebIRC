import flash.external.ExternalInterface;

import maroo.net.irc.IRCChannel;
import maroo.net.irc.IRCConnection;
import maroo.net.irc.IRCEvent;
import maroo.net.irc.IRCMessage;
import maroo.net.irc.IRCPrefix;
import maroo.net.irc.IRCServer;
import maroo.net.irc.IRCUser;
import maroo.net.irc.scripting.Environment;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.core.IRawChildrenContainer;
import mx.managers.FocusManager;

import nl.demonsters.debugger.MonsterDebugger;

import ui.Window;

[Bindable]
public var users:ArrayCollection = new ArrayCollection();

[Bindable]
public var channels:ArrayCollection = new ArrayCollection();

public var conn:IRCConnection;
public var scriptEnv:Environment;

private function init():void
{
	Security.loadPolicyFile("xmlsocket://webirc.ozinger.org:843"); 
	conn = new IRCConnection('webirc.ozinger.org');
	conn.addEventListener(Event.CONNECT, onConnect);
	conn.addEventListener(IRCEvent.MESSAGE, onMessage);
	scriptEnv = new Environment(this);
	
	ExternalInterface.addCallback('processInput', processInput);
	//var debugger:MonsterDebugger = MonsterDebugger(this);
	//MonsterDebugger.trace(this, 'init');
}

private function onConnect(event:Event):void
{
	conn.send('NICK maroo_webirc');
	conn.send('USER maroo1 maroo2 maroo3 maroo@aaa.com');
	conn.flush();
}

private function getTargetWindow(prefix:IRCPrefix):Window
{
	var win:Window;
	for (var i:int = 0, cnt:int = tabs.numElements; i < cnt; i++) {
		win = tabs.getItemAt(i) as Window;
		//Alert.show(win.label);
		if (win.prefix == prefix)
			return win;
	}

	win = new Window();
	win.prefix = prefix;
	tabs.addElement(win);
	return win;
	return tabs.selectedChild as Window;
}

private function onMessage(event:IRCEvent):void
{
	var message:IRCMessage = event.message;
	var win:Window;// = getTargetWindow(message);
	var chan:IRCChannel;
	var user:IRCUser;
	switch (message.command) {
		case 'JOIN':
			chan = conn.findChannel(message.params[1]);
			user = message.prefix as IRCUser;
			win = getTargetWindow(chan);
			win.users.addItem(user);
			//win.appendMessage(message);
			
			tabs.selectedChild = win;
			break;
		/*
		case '353':
			chan = conn.findChannel(message.params[1]);
			win = getTargetWindow(chan);
			break;
		*/
		case '366':
			chan = conn.findChannel(message.params[1]);
			win = getTargetWindow(chan);
			win.users.source = Array(chan.users);
			break;
		//case '332': // TOPIC_REPL
		//	break;
		case 'TOPIC':
			chan = conn.findChannel(message.params[message.params.length - 2]);
			win = getTargetWindow(chan);
			win.topic = message.text;
			break;
		case 'PRIVMSG':
			chan = conn.findChannel(message.params[0]);
			win = getTargetWindow(chan);
			win.appendMessage(message);
			break;
		case 'NOTICE': case '372':
		default:
			win = getTargetWindow(conn.server);
			win.appendMessage(message);
	}
}

public function processInput(str:String):void
{
	if (str.substr(0, 1) == '/') {
		// handle as command
		conn.send(str.substr(1));
		return;
		var parts:Array = str.substr(1).split(' ');
		var cmd:String = String(parts[0]).toUpperCase();
		switch (cmd) {
			case 'JOIN':
				conn.send('JOIN ' + parts[1]);
				break;
		}
		return;
	}
	conn.send('PRIVMSG ' + IRCPrefix(Window(tabs.selectedChild).prefix).name + ' :' + str);
}

private function sendLine(line:String):void
{
	conn.writeUTFBytes(line + '\r\n');
}

private function onInput(event:KeyboardEvent):void
{
	if (event.keyCode == Keyboard.ENTER) {
		processInput(event.target.text);
		event.target.text = '';
	}
}