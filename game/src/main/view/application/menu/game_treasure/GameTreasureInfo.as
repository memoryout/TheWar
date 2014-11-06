package main.view.application.menu.game_treasure
{
	import flash.display.MovieClip;
	
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	import main.view.application.menu.MenuPage;
	
	public class GameTreasureInfo extends MenuPage
	{
		private var _skin:			MovieClip;
		
		public function GameTreasureInfo()
		{
			super();
		}
		
		override protected function onCreate():void
		{
			var classRef:Class = AssetManager.getClass("ui","game.ui.menu.treasure");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				handlerChanges();
			}
		}
		
		override public function handlerChanges():void
		{
			_skin.scaleX = _skin.scaleY = AppSprite.getScaleFactor();
		}
	}
}