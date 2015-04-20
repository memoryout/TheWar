package main.view.application.menu.new_game
{
	import main.data.CivilizationInfo;
	import main.data.DataContainer;
	import main.data.MapInfo;
	import main.data.ScenarioInfo;
	import main.data.StartupGameConfiguration;
	import main.view.application.menu.MenuActionList;
	import main.view.application.menu.interfaces.IMenuPageController;
	import main.view.input.IInputHandler;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.IApplicationMenu;
	import main.view.interfaces.menu.IViewMenuStartPage;
	
	public class NewGamePageController implements IMenuPageController, IInputHandler
	{
		private var _menu:				IApplicationMenu;
		
		private var _pageView:			IViewMenuStartPage;
		private var _onPageComplete:	Function;
		
		public function NewGamePageController(fillType:String)
		{
			setConfig(fillType);
		}
		
		private function setConfig(fillType:String):void
		{
			if(fillType == "random")
			{
				var randScenario:ScenarioInfo = DataContainer.Get().getScenariousList()[(Math.floor(Math.random() * DataContainer.Get().getScenariousList().length))];
				
				var mapInfo:MapInfo = DataContainer.Get().getMapsList()[randScenario.mapId];								
				var civInfo:CivilizationInfo = randScenario.civilizations[Math.floor(Math.random() * randScenario.civilizations.length)];
				
				StartupGameConfiguration.Get().scenario 	= randScenario.id;
				StartupGameConfiguration.Get().civilization = civInfo.id;
				StartupGameConfiguration.Get().map 			= mapInfo.id;
				StartupGameConfiguration.Get().enemies		= randScenario.civilizations.length;
				
				StartupGameConfiguration.Get().civilizationName = civInfo.name;
				StartupGameConfiguration.Get().mapName 			= mapInfo.name;
			}
		}
		
		public function initialize(onCompleteCallback:Function):void
		{
			_onPageComplete = onCompleteCallback;
		}
		
		public function setView(menu:IApplicationMenu):void
		{
			_menu = menu;
			
			_pageView = _menu.showNewGamePage();
			_pageView.initialize(onViewInitComplete);
			
			UserInputSystem.get().registerInputActionHandler(this);
		}
		
		private function onViewInitComplete():void
		{
			_pageView.showPage();
		}
				
		public function handlerInputAction(type:String, button:String):void
		{
			switch(button)
			{
				case MenuActionList.MAP_BUTTON_CLICKED:
				{
					_pageView.hidePage();
					_onPageComplete(button);
					break;
				}
					
				case MenuActionList.CIVILIZATION_BUTTON_CLICKED:
				{
					_pageView.hidePage();
					_onPageComplete(button);
					break;
				}
					
				case MenuActionList.ENEMIES_BUTTON_CLICKED:
				{
					_pageView.hidePage();
					_onPageComplete(button);
					break;
				}
					
				case MenuActionList.LEVEL_BUTTON_CLICKED:
				{
					_pageView.hidePage();
					_onPageComplete(button);
					break;
				}
					
				case MenuActionList.START_GAME_BUTTON_CLICKED:
				{
					_pageView.hidePage();
					_onPageComplete(button);
					break;
				}
					
				case MenuActionList.BACK_NEW_BUTTON_CLICKED:
				{
					_pageView.hidePage();
					_onPageComplete(button);
					break;
				}
			}
		}
		
		public function destroy():void
		{
			UserInputSystem.get().removeInputActionHandler(this);
			
			if(_pageView) 
				_pageView.hidePage();
			
			_pageView 		= null;
			_onPageComplete = null;
			_menu 			= null;
		}
	}
}