package main.broadcast.message
{	
	import flash.utils.Dictionary;
	
	import main.broadcast.IModule;

	public class Dispatcher
	{	
		private var _messageList:				Object;
		
		
		public function Dispatcher()
		{
			_messageList = new Object();
		}
		
		
		/*public function addMessageListener(message:String, module:IBroadcastModule):void
		{
			if(!_messageList[message]) _messageList[message] = new Vector.<IBroadcastModule>;
			
			var v:Vector.<IBroadcastModule> = _messageList[message];
			
			if( v.indexOf(module) != -1) return;
			
			v.push(module);
		}
		*/
		
		public function removeMessageListener(message:String, module:IModule):void
		{
			if(!_messageList[message]) return;
			
			var v:Vector.<IModule> = _messageList[message];
			var index:int = v.indexOf(module)
			
			if( index != -1)
			{
				v.splice(index, 1);
			}
			
			if(v.length == 0) delete _messageList[message];
		}
		
		
		public function sendMessage(message:String, modules:Vector.<Object>, data:* = null):MessageData
		{				
			var messageData:MessageData = new MessageData(message, data);

			for (var key:* in modules) 
			{
				modules[key].receiveMessage( messageData );
			}
			
			return messageData;
		}
	}
}