package main.view.application.menu
{
	
	import core.logic.events.CoreEvents;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.view.IRootLayout;
	import main.view.ViewEvent;
	import main.view.application.menu.civilizations.CivilizationsPageController;
	import main.view.application.menu.enemies.EnemiesPageController;
	import main.view.application.menu.interfaces.IMenuPageController;
	import main.view.application.menu.level.LevelPageController;
	import main.view.application.menu.map.MapPageController;
	import main.view.application.menu.new_game.NewGamePageController;
	import main.view.application.menu.scenario.ScenarioPageController;
	import main.view.application.menu.scenario.ScenarioSettingsPageController;
	import main.view.application.menu.start.StartPageController;
	import main.view.interfaces.IApplicationMenu;
	
	public class ApplicationMenuController extends Module
	{
		public static const MODULE_NAME:	String = "app.menu_controller";
		
		private var _menuView:			IApplicationMenu;
		private var _rootLayout:		IRootLayout;
				
		private var _currentController:	IMenuPageController;
		
		private var _onStartGameCallback:Function;
		
		private var lastPage			:String;
		
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
		
		private function showNewGamePage(fillType:String):void
		{
			_currentController = new NewGamePageController(fillType);
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
		
		private function showCivilizationsPage():void
		{
			_currentController = new CivilizationsPageController();
			_currentController.initialize(onCivResult);
			_currentController.setView( _menuView );
		}
		
		private function showScenarioSettingsPage():void
		{
			_currentController = new ScenarioSettingsPageController();
			_currentController.initialize(onScenarioSettingsResult);
			_currentController.setView( _menuView );
		}
		
		private function showLevelPage():void
		{
			_currentController = new LevelPageController();
			_currentController.initialize(onLevelResult);
			_currentController.setView( _menuView );
		}
		
		private function showEnemiesPage():void
		{
			_currentController = new EnemiesPageController();
			_currentController.initialize(onEnemiesResult);
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
					showNewGamePage("random");
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
					
				case MenuActionList.CIVILIZATION_BUTTON_CLICKED:
				{
					showCivilizationsPage();
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
					
				case MenuActionList.ENEMIES_BUTTON_CLICKED:
				{					
					showEnemiesPage();
					
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
				case MenuActionList.BACK_SCENARIO_BUTTON_CLICKED:
				{
					showStartPage();
					break;
				}
				
				case MenuActionList.SCENARIO_ITEM_BUTTON_CLICKED:
				{
					showScenarioSettingsPage();
					break;
				}
			}
		}
		
		private function onScenarioSettingsResult(page:String):void
		{			
			_currentController.destroy();
			_currentController = null;
			
			lastPage = "onScenarioSettingsResult";
			
			switch(page)
			{
				case MenuActionList.CIV_SETTINGS_BUTTON_CLICKED:
				{
					showCivilizationsPage();
					break;
				}
					
				case MenuActionList.LEVEL_SETTINGS_BUTTON_CLICKED:
				{
					showLevelPage();
					break;
				}
					
				case MenuActionList.START_SETTINGS_BUTTON_CLICKED:
				{
					sendMessage(ViewEvent.START_SINGLE_GAME);
					break;
				}
					
				case MenuActionList.BACK_SETTINGS_BUTTON_CLICKED:
				{
					showScenarioPage();
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
					showNewGamePage("config");
					break;
				}
			}
		}
		
		private function onCivResult(page:String):void
		{			
			_currentController.destroy();
			_currentController = null;
			
			switch(page)
			{
				case MenuActionList.CIVILIZATION_ITEM_BUTTON_CLICKED:
					
				case MenuActionList.BACK_CIV_BUTTON_CLICKED:	
				{					
					if(lastPage == "onScenarioSettingsResult")
						showScenarioSettingsPage();
						
					else
						showNewGamePage("config");
					
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
					if(lastPage == "onScenarioSettingsResult")
						showScenarioSettingsPage();
					
					else
						showNewGamePage("config");
					
					break;
				}
			}
		}
		
		private function onEnemiesResult(page:String):void
		{			
			_currentController.destroy();
			_currentController = null;
			
			switch(page)
			{								
				case MenuActionList.BACK_ENEMIES_BUTTON_CLICKED:
				{						
					showNewGamePage("config");
					
					break;
				}
					
				case MenuActionList.ENEMIES_ITEM_BUTTON_CLICKED:
				{						
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