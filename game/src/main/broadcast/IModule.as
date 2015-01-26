package main.broadcast
{
	import main.broadcast.message.MessageData;

	public interface IModule
	{
		function sendMessage(messageId:String, data:* = null):MessageData;
		function receiveMessage(message:MessageData):void;
		function listNotificationInterests():Array;
	}
}