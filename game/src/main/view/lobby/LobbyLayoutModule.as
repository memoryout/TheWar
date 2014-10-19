package main.view.lobby
{
	import flash.display.Sprite;
	
	import main.broadcast.Module;
	
	public class LobbyLayoutModule extends Module
	{
		private var _lobbyLayout:			LobbyLayout;
		
		public function LobbyLayoutModule()
		{
			super();
		}
		
		public function initialize(container:Sprite):void
		{
			_lobbyLayout = new LobbyLayout();
			container.addChild( _lobbyLayout );
			
			_lobbyLayout.init();
		}
	}
}