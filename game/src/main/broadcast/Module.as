package main.broadcast
{	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import main.broadcast.message.Dispatcher;
	import main.broadcast.message.MessageData;
	
	public class Module implements IModule
	{
		private static const _broadcastDispacther:		Dispatcher = new Dispatcher();
		
		private static const MODULES:					Vector.<Object> = new Vector.<Object>();
		
		private var _messages:				Object;
		
		
		public function Module()
		{
			super();
			
			_messages = new Object();
		}
		
		/*protected function addMessageListener(messageId:String):void
		{
			_messages[messageId] = messageId;
			_broadcastDispacther.addMessageListener( messageId, this );
		}*/
		
		protected function removeMessageListener(messageId:String):void
		{
			delete _messages[messageId];
			_broadcastDispacther.removeMessageListener( messageId, this );
		}
		
		protected function sendMessage(messageId:String, data:* = null):MessageData
		{
			return _broadcastDispacther.sendMessage(messageId, MODULES, data);
		}
		
		
		protected function setSharedModule(name:String, module:Module):void
		{
			MODULES.push(module);
		}
		/*
		protected function getSharedModule(name:String):Vector.<Object>
		{
			return MODULES[name];
		}*/
		
		
		public function receiveMessage(message:MessageData):void
		{			
		}
		
		
		public function destroy():void
		{
			var par:String;
			for(par in _messages)
			{
				_broadcastDispacther.removeMessageListener( _messages[par], this );
				delete _messages[par]
			}
			
			_messages = null;
		}
	}
}