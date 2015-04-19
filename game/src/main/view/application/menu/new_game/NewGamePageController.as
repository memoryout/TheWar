package main.view.application.menu.new_game
{
	import main.view.application.data.StartupGameConfiguration;
	import main.view.application.menu.MenuActionList;
	import main.view.application.menu.interfaces.IMenuPageController;
	import main.view.input.IInputHandler;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.IApplicationMenu;
	import main.view.interfaces.menu.IViewMenuStartPage;
	
	public class NewGamePageController implements IMenuPageController, IInputHandler
	{
		private var _startupConfig:		StartupGameConfiguration;
		private var _menu:				IApplicationMenu;
		
		private var _pageView:			IViewMenuStartPage;
		private var _onPageComplete:	Function;
		
		public function NewGamePageController()
		{
		}
		
		public function initialize(data:StartupGameConfiguration, onCompleteCallback:Function):void
		{
			_startupConfig = data;
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
					
				case MenuActionList.BACK_GAME_BUTTON_CLICKED:
				{
					_pageView.hidePage();
					_onPageComplete(button);
					break;
				}
			}
		}
		
		public function destroy():void
		{
			if(_pageView) 
				_pageView.hidePage();
			
			_pageView 		= null;
			_onPageComplete = null;
			_menu 			= null;
			_startupConfig 	= null;
		}
	}
}