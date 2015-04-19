package main.view.application.menu
{
	import avm2.intrinsics.memory.casi32;
	
	import core.logic.events.CoreEvents;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.view.IRootLayout;
	import main.view.ViewEvent;
	import main.view.application.menu.interfaces.IMenuPageController;
	import main.view.application.menu.level.LevelPageController;
	import main.view.application.menu.map.MapPageController;
	import main.view.application.menu.new_game.NewGamePageController;
	import main.view.application.menu.scenario.ScenarioPageController;
	import main.view.application.menu.start.StartPageController;
	import main.view.interfaces.IApplicationMenu;
	
	public class ApplicationMenuController extends Module
	{
		public static const MODULE_NAME:	String = "app.menu_controller";
		
		private var _menuView:			IApplicationMenu;
		private var _rootLayout:		IRootLayout;
				
		private var _currentController:	IMenuPageController;
		
		private var _onStartGameCallback:Function;
		
		public function ApplicationMenuController()
		{
			super(this);
		}
		
		
		public function initialize(rootLayout:IRootLayout):void
		{
			_rootLayout = rootLayout;
			_menuView = rootLayout.getMenuView();
			_menuView.initialize(onMenuViewInitComplete);
		}
		
		public function unload():void
		{
			_menuView.unload();
			
			if(_currentController) 
				_currentController.destroy();
		}
		
		
		private function onMenuViewInitComplete():void
		{
			_rootLayout.showApplicationMenu();
			
			startNewSession();	
		}
		
		private function startNewSession():void
		{
			_menuView.showBackground();
			
			showStartPage();
		}
		
		private function showStartPage():void
		{
			_currentController = new StartPageController();
			_currentController.initialize(onStartPageResult);
			_currentController.setView( _menuView );
		}
		
		private function showNewGamePage():void
		{
			_currentController = new NewGamePageController();
			_currentController.initialize(onNewGameResult);
			_currentController.setView( _menuView );
		}
		
		private function showScenarioPage():void
		{
			_currentController = new ScenarioPageController();
			_currentController.initialize(onScenarioResult);
			_currentController.setView( _menuView );
		}
		
		private function showMapPage():void
		{
			_currentController = new MapPageController();
			_currentController.initialize(onMapResult);
			_currentController.setView( _menuView );
		}
		
		private function showLevelPage():void
		{
			_currentController = new LevelPageController();
			_currentController.initialize(onLevelResult);
			_currentController.setView( _menuView );
		}
		
		private function onStartPageResult(page:String):void
		{			
			_currentController.destroy();
			_currentController = null;
						
			switch(page)
			{
				case MenuActionList.NEW_GAME_BUTTON_CLICKED:
				{
					showNewGamePage();
					break;
				}
					
				case MenuActionList.LOAD_GAME_BUTTON_CLICKED:
				{
					break;
				}
					
				case MenuActionList.SCENARIO_BUTTON_CLICKED:
				{
					showScenarioPage();
					break;
				}
					
				/*case MenuActionList.OPEN_CREDITS_PAGE:
				{
					break;
				}*/
			}
			
			
//			sendMessage(ViewEvent.START_SINGLE_GAME, _startupGameConfig);
		}
		
		private function onNewGameResult(page:String):void
		{			
			_currentController.destroy();
			_currentController = null;
			
			switch(page)
			{
				case MenuActionList.MAP_BUTTON_CLICKED:
				{
					showMapPage();
					break;
				}
				
				case MenuActionList.LEVEL_BUTTON_CLICKED:
				{
					showLevelPage();
					break;
				}
				
				case MenuActionList.START_GAME_BUTTON_CLICKED:
				{
					sendMessage(ViewEvent.START_SINGLE_GAME);
					break;
				}
					
				case MenuActionList.BACK_NEW_BUTTON_CLICKED:
				{
					showStartPage();
					break;
				}
			}
		}
		
		private function onScenarioResult(page:String):void
		{			
			_currentController.destroy();
			_currentController = null;
			
			switch(page)
			{
				case MenuActionList.SCENARIO_ITEM_BUTTON_CLICKED:
				{
//					showLevelPage();
					break;
				}
			}
		}
		
		private function onMapResult(page:String):void
		{			
			_currentController.destroy();
			_currentController = null;
			
			switch(page)
			{
				case MenuActionList.MAP_ITEM_BUTTON_CLICKED:
					
				case MenuActionList.BACK_MAP_BUTTON_CLICKED:	
				{
					showNewGamePage();
					break;
				}
			}
		}
		
		private function onLevelResult(page:String):void
		{			
			_currentController.destroy();
			_currentController = null;
			
			switch(page)
			{
				case MenuActionList.LOW_LEVEL_BUTTON_CLICKED:
				case MenuActionList.MIDDLE_LEVEL_BUTTON_CLICKED:
				case MenuActionList.HIGH_LEVEL_BUTTON_CLICKED:					
				case MenuActionList.BACK_LEVEL_BUTTON_CLICKED:
				{
					showNewGamePage();
					break;
				}
			}
		}
		
		override public function receiveMessage(message:MessageData):void
		{		
			switch(message.message)
			{
				case ViewEvent.OPEN_NEW_GAME_PAGE:
				{
					break;
				}
					
				case ViewEvent.OPEN_LOAD_GAME_PAGE:
				{
					break;
				}
					
				case ViewEvent.OPEN_SCENARION_PAGE:
				{
					break;
				}
					
				case ViewEvent.OPEN_CREDITS_PAGE:
				{
					break;
				}
			}
		}
	}
}