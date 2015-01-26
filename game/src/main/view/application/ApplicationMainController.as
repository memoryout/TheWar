package main.view.application
{
	import core.logic.events.CoreEvents;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.view.IRootLayout;
	import main.view.application.game.GameController;
	import main.view.application.menu.ApplicationMenuController;
	import main.view.application.preloader.GameSourceLoader;
	
	public class ApplicationMainController extends Module
	{
		public static const MODULE_NAME:	String = "app.main_controller";
		
		private var _rootLayout:			IRootLayout;
		
		private var _menuController:		ApplicationMenuController;
		
		private var _gameSourceLoader:		GameSourceLoader;
		
		private var _gameController:		GameController;
		
		public function ApplicationMainController()
		{
			super(this);
		}
		
		
		public function initialize(rootLayout:IRootLayout):void
		{
			_rootLayout = rootLayout;
			
			_rootLayout.initialize();
			
			createMenu();
		}
		
		private function createMenu():void
		{
			_menuController = new ApplicationMenuController();
			_menuController.initialize( _rootLayout );
			
		}
		
		
		private function startNewGame():void
		{
			_menuController.unload();
			_rootLayout.hideApplicationMenu();
			
			_gameSourceLoader = new GameSourceLoader();
			_gameSourceLoader.setOnSuccess( onGameResourceLoadComplete);
			_gameSourceLoader.setLayout( _rootLayout );
		}
		
		private function onGameResourceLoadComplete():void
		{
			_gameSourceLoader.destroy();
			_rootLayout.removeLoaderScreen();
			
			_gameController = new GameController();
			_gameController.initialize(_rootLayout);
		}
		
		override public function listNotificationInterests():Array
		{
			return [CoreEvents.GAME_READY
			];
		}
		
		override public function receiveMessage(message:MessageData):void
		{
			switch(message.message)
			{
				case CoreEvents.GAME_READY:
				{
					startNewGame();
					break;
				}
			}
		}
	}
}