package main.view.application.menu.game_step_statistics
{
	import flash.display.MovieClip;
	
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	import main.view.application.menu.MenuPage;
	
	public class GameStepStatistic extends MenuPage
	{
		private var _skin:			MovieClip;
		
		public function GameStepStatistic()
		{
			super();
		}
		
		override protected function onCreate():void
		{
			var classRef:Class = AssetManager.getClass("ui","game.ui.menu.step_statistic");
			
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