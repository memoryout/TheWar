package main.view.application.menu.settings
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	import main.view.application.menu.MenuPage;
	
	public class GameSettingsPage extends MenuPage
	{
		private var _skin:			MovieClip;
		
		public function GameSettingsPage()
		{
			super();
		}
		
		
		override protected function onCreate():void
		{
			var classRef:Class = AssetManager.getClass("ui","ui.menu.game_settings_page");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				var mc:MovieClip = _skin.getChildByName("btStart") as MovieClip;
				
				mc.addEventListener(MouseEvent.CLICK, handlerClickStart);
				
				handlerChanges();
			}
		}
		
		override public function handlerChanges():void
		{
			if(_skin)
			{
				_skin.scaleX = _skin.scaleY = AppSprite.getScaleFactor();
				
				_skin.x = AppSprite.getScreenSize().width;
			}
		}
		
		
		
		private function handlerClickStart(e:MouseEvent):void
		{
			this.receiver.handleMenuPageResult("start_game");
		}
	}
}