package main.broadcast
{	
	import main.broadcast.message.MessageData;
	
	public class Module implements IModule
	{		
		private static const MODULES:Vector.<IModule> = new Vector.<IModule>();		
		
		public function Module(moduleLink:IModule = null)
		{
			MODULES.push(moduleLink);			
		}
				
		public function sendMessage(messageId:String, data:* = null):MessageData
		{
			var messageData:MessageData = new MessageData(messageId, data);				
			
			for (var key:* in MODULES) 
			{
				if(MODULES[key].listNotificationInterests().indexOf(messageId) != -1)
				{
					MODULES[key].receiveMessage( messageData );
				}				
			}
			
			return messageData;
		}
			
		
		public function receiveMessage(message:MessageData):void
		{			
		}
		
		public function listNotificationInterests():Array 
		{
			return [];
		}
	}
}