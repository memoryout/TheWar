package main.view
{
	import flash.display.Stage;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.events.ApplicationEvents;
	import main.view.lobby.LobbyLayoutModule;
	
	public class ApplicationMainLayoutModule extends Module
	{
		public static const MODULE_NAME:		String = "app.view.main-layout";
		
		private var _mainLayout:				ApplicationMainLayout;
		
		private var _lobby:						LobbyLayoutModule;
		
		public function ApplicationMainLayoutModule()
		{
			super();
			
			setSharedModule( MODULE_NAME, this );
		}
		
		public function initialize(stage:Stage):void
		{
			_mainLayout = new ApplicationMainLayout();
			stage.addChild( _mainLayout );
			
			
		}
		
		
		override public function receiveMessage(message:MessageData):void
		{
			switch(message.message)
			{
				case ApplicationEvents.SOURCES_LOADED:
				{
					_mainLayout.initialize();
					
					createLobby();
					
					break;
				}
			}
		}
		
		private function createLobby():void
		{
			_lobby = new LobbyLayoutModule();
			_lobby.initialize( _mainLayout.canvas );
		}
	}
}