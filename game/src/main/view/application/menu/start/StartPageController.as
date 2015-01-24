package main.view.application.menu.start
{
	import main.view.application.data.StartupGameConfiguration;
	import main.view.application.menu.IMenuPageController;
	import main.view.application.menu.MenuActionList;
	import main.view.input.IInputHandler;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.IApplicationMenu;
	import main.view.interfaces.menu.IViewMenuStartPage;

	public class StartPageController implements IMenuPageController, IInputHandler
	{
		private var _startupConfig:		StartupGameConfiguration;
		private var _menu:				IApplicationMenu;
		
		private var _pageView:			IViewMenuStartPage;
		private var _onPageComplete:	Function;
		
		public function StartPageController()
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
			
			_pageView = _menu.showStartPage();
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
				case MenuActionList.START_NEW_GAME:
				{
					_pageView.hidePage();
					_onPageComplete();
					break;
				}
			}
		}
		
		
		public function destroy():void
		{
			if(_pageView) _pageView.hidePage();
			
			_pageView = null;
			_onPageComplete = null;
			_menu = null;
			_startupConfig = null;
		}
	}
}