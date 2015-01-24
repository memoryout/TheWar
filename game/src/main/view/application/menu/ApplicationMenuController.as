package main.view.application.menu
{
	import core.logic.events.CoreEvents;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.view.IRootLayout;
	import main.view.ViewEvent;
	import main.view.application.data.StartupGameConfiguration;
	import main.view.application.menu.start.StartPageController;
	import main.view.interfaces.IApplicationMenu;
	
	public class ApplicationMenuController extends Module
	{
		public static const MODULE_NAME:	String = "app.menu_controller";
		
		private var _menuView:			IApplicationMenu;
		private var _rootLayout:		IRootLayout;
		
		private var _startupGameConfig:	StartupGameConfiguration;
		
		private var _currentController:	IMenuPageController;
		
		private var _onStartGameCallback:Function;
		
		public function ApplicationMenuController()
		{
			super();
			
			this.setSharedModule( MODULE_NAME, this );
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
			
			if(_currentController) _currentController.destroy();
		}
		
		
		private function onMenuViewInitComplete():void
		{
			_rootLayout.showApplicationMenu();
			
			startNewSession();	
		}
		
		private function startNewSession():void
		{
			_startupGameConfig = new StartupGameConfiguration();
			
			_menuView.showBackground();
			
			showStartPage();
		}
		
		private function showStartPage():void
		{
			_currentController = new StartPageController();
			_currentController.initialize(_startupGameConfig, onStartPageResult);
			_currentController.setView( _menuView );
		}
		
		private function onStartPageResult():void
		{
			sendMessage(ViewEvent.START_SINGLE_GAME, _startupGameConfig);
		}
	}
}