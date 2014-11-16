package main.view.application.game.windows.action
{
	import flash.events.Event;
	
	import main.broadcast.Module;
	import main.view.ViewEvent;
	import main.view.application.game.windows.IWindowController;
	import main.view.application.game.windows.SimpleWindow;
	
	public class MakeActionWindowController extends Module implements IWindowController
	{
		private var _window:			MakeActionWindow;
		
		public function MakeActionWindowController()
		{
			super();
			
			createWindowInstance();
		}
		
		public function getWindowInstance():SimpleWindow
		{
			return _window;
		}
		
		
		
		private function createWindowInstance():void
		{
			_window = new MakeActionWindow();
			_window.addEventListener(Event.ADDED_TO_STAGE, handlerWindowReady);
		}
		
		private function handlerWindowReady(e:Event):void
		{
			_window.removeEventListener(Event.ADDED_TO_STAGE, handlerWindowReady);
			
			_window.addEventListener(MakeActionWindow.SEND, handlerSendClick);
		}
		
		private function handlerSendClick(e:Event):void
		{
			_window.removeEventListener(MakeActionWindow.SEND, handlerSendClick);
			
			var message:String = _window.getActionDescription();
			var data:Object;
			
			try
			{
				data = JSON.parse(message);
			}
			catch(e:Error)
			{
				trace(e);
			}
			
			if(data) sendMessage(ViewEvent.SET_ACTION, data);
			
			_window.hide();
			_window = null;
		}
	}
}