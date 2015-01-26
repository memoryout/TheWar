package main.broadcast.message
{
	public class MessageData
	{
		public var  data:*;		
		private var _messageId:String;
		
		public function MessageData(messageId:String, data:*)
		{
			_messageId = messageId;
			this.data = data;
		}
		
		public function get message():String
		{
			return _messageId;
		}
	}
}