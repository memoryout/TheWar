package main.view.application.menu.game_step_statistics
{
	import flash.display.MovieClip;
	
	import main.view.R;
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
			var classRef:Class = R.getClass("game.ui.menu.step_statistic");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
			}
		}
	}
}