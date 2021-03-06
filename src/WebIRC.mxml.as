import flash.events.Event;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;

import maroo.net.irc.IRCChannel;
import maroo.net.irc.IRCChannelEvent;
import maroo.net.irc.IRCConnection;
import maroo.net.irc.IRCConstant;
import maroo.net.irc.IRCEvent;
import maroo.net.irc.IRCMessage;
import maroo.net.irc.IRCPrefix;
import maroo.net.irc.IRCServer;
import maroo.net.irc.IRCUser;
import maroo.net.irc.IRCUserEvent;
import maroo.net.irc.scripting.Environment;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.core.Application;
import mx.core.IFlexDisplayObject;
import mx.core.IRawChildrenContainer;
import mx.managers.FocusManager;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;

import nl.demonsters.debugger.MonsterDebugger;

import ui.ConnectionDialog;
import ui.NicknameDialog;
import ui.ScriptEditor;
import ui.Window;

[Bindable]
public var users:ArrayCollection = new ArrayCollection();

[Bindable]
public var channels:ArrayCollection = new ArrayCollection();

public var conn:IRCConnection;
public var scriptEnv:Environment;

private var _me:IRCUser;
public function get me():IRCUser { return _me; }

private function init():void
{
	scriptEnv = new Environment(this);
	
	ExternalInterface.addCallback('processInput', processInput);
	ExternalInterface.addCallback('showNicknameDialog', showNicknameDialog);
	var connectionDialog:IFlexDisplayObject = PopUpManager.createPopUp(this, ConnectionDialog, true);
	PopUpManager.centerPopUp(connectionDialog);
	connect();
}

private function connect():void
{
	Security.loadPolicyFile("xmlsocket://webirc.ozinger.org:843"); 
	conn = new IRCConnection('webirc.ozinger.org');
	conn.addEventListener(Event.CONNECT, onConnect);
	conn.addEventListener(IRCEvent.MESSAGE, onMessage);
	conn.addEventListener(IRCChannelEvent.JOIN, onJoinChannel);
	conn.addEventListener(IRCChannelEvent.PART, onPartChannel);
	//conn.addEventListener(IRCChannelEvent.INVITE, onChannelEvent);
	//conn.addEventListener(IRCChannelEvent.KICK, onChannelEvent);
	conn.addEventListener(IRCChannelEvent.MODE, onChannelMode);
	conn.addEventListener(IRCChannelEvent.OP, onChannelPermission);
	conn.addEventListener(IRCChannelEvent.DEOP, onChannelPermission);
	conn.addEventListener(IRCChannelEvent.VOICE, onChannelPermission);
	conn.addEventListener(IRCChannelEvent.DEVOICE, onChannelPermission);
	conn.addEventListener(IRCUserEvent.PRIVMSG, onUserEvent);
	//conn.addEventListener(IRCUserEvent.MODE, onUserEvent);
}

private function onConnect(event:Event):void
{
	conn.send('NICK maroo_webirc');
	conn.send('USER maroo1 maroo2 maroo3 maroo@webirc.ozinger.com');
	conn.flush();
}

private function getTargetWindow(prefix:IRCPrefix):Window
{
	var win:Window;
	for (var i:int = 0, cnt:int = tabs.numElements - 1; i < cnt; i++) {
		win = tabs.getItemAt(i) as Window;
		if (win.prefix.name == prefix.name)
			return win;
	}

	win = new Window();
	win.prefix = prefix;
	//tabs.addElement(win);
	tabs.addElementAt(win, cnt);
	return win;
}

public function get currentWindow():Window
{
	return tabs.selectedChild as Window;
}

private function onMessage(event:IRCEvent):void
{
	var message:IRCMessage = event.message;
	var win:Window;// = getTargetWindow(message);
	var chan:IRCChannel;
	var user:IRCUser;
	switch (message.command) {
		case '001':	// RPL_WELCOME
			_me = conn.findUser(message.text.split(/\s+/).pop());
			ExternalInterface.call('webIRC.onNick', _me.nick);
			break;
		case IRCConstant.RPL_ENDOFNAMES: // '366'
			chan = conn.findChannel(message.params[1]);
			win = getTargetWindow(chan);
			for each (user in chan.users) {
				win.addUser(user);
			}
			break;
		case IRCConstant.RPL_TOPIC: // '332'
		case 'TOPIC':
			chan = conn.findChannel(message.params[message.params.length - 2]);
			win = getTargetWindow(chan);
			win.topic = message.text;
			break;
		case 'PART':
			break;
		case 'QUIT':
			user = message.prefix as IRCUser;
			
			break;
		case '443':	// duplicate nick 
			break;
		case 'NOTICE': case '372':
		default:
			win = getTargetWindow(conn.server);
			win.appendText(message.raw);
			//win.appendMessage(message);
	}
}

private function onJoinChannel(event:IRCChannelEvent):void
{
	var win:Window = getTargetWindow(event.channel);
	win.addUser(event.toUser);
	tabs.selectedChild = win;
	if (event.toUser == me) {
		win.appendMessage(event.message);
	}
}

private function onPartChannel(event:IRCChannelEvent):void
{
	var win:Window = getTargetWindow(event.channel);
	if (event.toUser == me) {
		tabs.removeChild(win);
	} else {
		win.removeUser(event.toUser);
	}
}

private function onChannelMode(event:IRCChannelEvent):void
{
	var channel:IRCChannel = event.channel;
	channel.setMode(event.mode);
	var win:Window = getTargetWindow(channel);
	//win.refreshUsers();
	win.appendMessage(event.message);
}

private function onChannelPermission(event:IRCChannelEvent):void
{
	if (event.type == IRCChannelEvent.OP)
		event.toUser.isOper = true;
	if (event.type == IRCChannelEvent.DEOP)
		event.toUser.isOper = false;
	if (event.type == IRCChannelEvent.VOICE)
		event.toUser.isVoice = true;
	if (event.type == IRCChannelEvent.DEVOICE)
		event.toUser.isVoice = false;
	var channel:IRCChannel = event.channel;
	var win:Window = getTargetWindow(channel);
	win.refreshUsers();
}

public function processInput(str:String):void
{
	if (!str) return;
	if (str.substr(0, 1) == '/') {
		// handle as command
		//conn.send(str.substr(1));
		//return;
		var parts:Array = str.substr(1).split(' ');
		parts.unshift(String(parts.shift()).toUpperCase());
		conn.send(parts.join(' '));
		return;
	}
	conn.send('PRIVMSG ' + IRCPrefix(currentWindow.prefix).name + ' :' + str);
	var msg:IRCMessage = new IRCMessage('PRIVMSG', me, [StringUtil.trim(str)]);
	currentWindow.appendMessage(msg);
}

private function onUserEvent(event:IRCUserEvent):void
{
	var win:Window;
	if (event.channel)
		win = getTargetWindow(event.channel);
	else
		win = getTargetWindow(event.message.prefix);
	win.appendMessage(event.message);
}

public function showNicknameDialog():void
{
	//var nicknameDialog:IFlexDisplayObject = PopUpManager.createPopUp(this, NicknameDialog);
	var nicknameDialog:IFlexDisplayObject = PopUpManager.createPopUp(this, ScriptEditor);
	PopUpManager.centerPopUp(nicknameDialog);
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

private function onNewTabClick(event:Event):void
{
	Alert.show('new tab button clicked');
}