package main.view.application.game.windows.action
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	import main.view.application.game.windows.SimpleWindow;
	import main.view.input.UserInputSystem;
	
	public class MakeActionWindow extends SimpleWindow
	{
		public static const SEND:	String = "send";
		
		private var _skin:			MovieClip;
		
		public function MakeActionWindow()
		{
			super();
		}
		
		public function getActionDescription():String
		{
			return _skin.txtSource.text;
		}
		
		override protected function onCreate():void
		{
			var classRef:Class = AssetManager.getClass("ui","gWindowMakeAction");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				var bt:MovieClip = _skin.getChildByName("btSend") as MovieClip;
				bt.addEventListener(MouseEvent.CLICK, handlerClickSend);
				
				_skin.scaleX = _skin.scaleY = AppSprite.getScaleFactor();
			}
		}
		
		private function handlerClickSend(e:MouseEvent):void
		{
			this.dispatchEvent( new Event(SEND) );
		}
	}
}