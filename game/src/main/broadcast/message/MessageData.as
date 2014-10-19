package main.broadcast.message
{
	public class MessageData
	{
		public var data:		*;
		
		
		private var _message:		String;
		
		public function MessageData(messageId:String, data:*)
		{
			_message = messageId;
			this.data = data;
		}
		
		public function get message():String
		{
			return _message;
		}
	}
}