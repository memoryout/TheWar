package main.broadcast
{
	import flash.events.IEventDispatcher;
	
	import main.broadcast.message.MessageData;

	public interface IModule
	{
		function receiveMessage(message:MessageData):void;
		function destroy():void;
	}
}