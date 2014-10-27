package main.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import main.view.R;
	
	public class GameLayout extends Sprite
	{
		private var _skin:			MovieClip;
		
		public function GameLayout()
		{
			super();
		}
		
		
		public function load():void
		{
			var classRef:Class = R.getClass("game.map_01");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
			}
		}
	}
}