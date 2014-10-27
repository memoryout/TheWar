package main.view.application.game
{
	import flash.display.Sprite;
	
	import main.broadcast.Module;
	
	public class GameLayoutContext extends Module
	{
		private const MODULE_NAME:		String = "game_context";
		
		private var _gameLayout:		GameLayout;
		
		public function GameLayoutContext()
		{
			super();
			
			this.setSharedModule(MODULE_NAME, this);
		}
		
		
		public function initialize(layout:Sprite):void
		{
			_gameLayout = new GameLayout();
			layout.addChild( _gameLayout );
			_gameLayout.load();
		}
	}
}