package main.view.input
{
	import flash.utils.Dictionary;

	public class UserInputSystem
	{
		private static var _instance:			UserInputSystem;
		
		private const _handlers:		Vector.<IInputHandler> = new Vector.<IInputHandler>();
		
		public function UserInputSystem()
		{
			
		}
		
		public static function get():UserInputSystem
		{
			if(_instance == null) _instance = new UserInputSystem();
			return _instance;
		}
		
		public function registerInputActionHandler(handler:IInputHandler):void
		{
			var i:int;
			for(i = 0; i < _handlers.length; i++)
			{
				if(_handlers[i] == handler) return;
			}
			
			_handlers.push(handler);
		}
		
		public function removeInputActionHandler(handler:IInputHandler):void
		{
			var i:int;
			for(i = 0; i < _handlers.length; i++)
			{
				if(_handlers[i] == handler)
				{
					_handlers.splice(i, 1);
					return;
				}
			}
		}
		
		public function processAction(action:String, button:String):void
		{
			var i:int;
			for(i = 0; i < _handlers.length; i++)
			{
				_handlers[i].handlerInputAction(action, button);
			}
		}
	}
}