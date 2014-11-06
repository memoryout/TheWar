package main.view.application.menu.game_civ_order
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	import main.view.application.menu.MenuPage;
	
	public class GameCivOrder extends MenuPage
	{
		private var _skin:			MovieClip;
		
		public function GameCivOrder()
		{
			super();
		}
		
		override protected function onCreate():void
		{
			var classRef:Class = AssetManager.getClass("ui","game.ui.menu.civilization_order");
			
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