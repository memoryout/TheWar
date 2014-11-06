package main.view.application.menu.start
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	import main.view.application.menu.MenuPage;
	
	public class StartPageMenu extends MenuPage
	{
		private var _skin:			MovieClip;
		
		public function StartPageMenu()
		{
			super();
		}
		
		override protected function onCreate():void
		{
			var classRef:Class = AssetManager.getClass("ui","ui.menu.start_page");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				
				var mc:MovieClip = _skin.getChildByName("btNewGame") as MovieClip;
				mc.addEventListener(MouseEvent.CLICK, handlerClickNewGame);
				
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
		
		
		private function handlerClickNewGame(e:MouseEvent):void
		{
			this.receiver.handleMenuPageResult("new_game");
		}
	}
}