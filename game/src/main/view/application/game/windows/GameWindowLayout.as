package main.view.application.game.windows
{
	import flash.display.Sprite;
	
	public class GameWindowLayout extends Sprite
	{
		private var _currentWindow:			SimpleWindow;
		
		public function GameWindowLayout()
		{
			super();
			
			this.mouseEnabled = false;
		}
		
		public function showWindow(window:IWindowController):void
		{
			var win:SimpleWindow = window.getWindowInstance();
			if(win) 
			{
				this.addChild(win);
				win.show();
			}
		}
		
		public function closeWindow():void
		{
			
		}
	}
}