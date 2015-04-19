package main.view.application.menu.level
{
	import core.logic.LogicData;
	
	import main.data.StartupGameConfiguration;
	import main.view.application.menu.MenuActionList;
	import main.view.application.menu.interfaces.IMenuPageController;
	import main.view.input.IInputHandler;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.IApplicationMenu;
	import main.view.interfaces.menu.IViewMenuStartPage;
	
	public class LevelPageController implements IMenuPageController, IInputHandler
	{
		private var _menu:				IApplicationMenu;
		
		private var _pageView:			IViewMenuStartPage;
		private var _onPageComplete:	Function;
		
		public function LevelPageController()
		{
		}
		
		public function initialize(onCompleteCallback:Function):void
		{
			_onPageComplete = onCompleteCallback;
		}
		
		public function setView(menu:IApplicationMenu):void
		{
			_menu = menu;
			
			_pageView = _menu.showLevelPage();
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
				case MenuActionList.LOW_LEVEL_BUTTON_CLICKED:
				{
					StartupGameConfiguration.Get().level = 0;						
					
					_pageView.hidePage();
					_onPageComplete(button);			
					
					break;
				}
					
				case MenuActionList.MIDDLE_LEVEL_BUTTON_CLICKED:
				{
					StartupGameConfiguration.Get().level = 1;					
					
					_pageView.hidePage();
					_onPageComplete(button);
					
					break;
				}
					
				case MenuActionList.HIGH_LEVEL_BUTTON_CLICKED:
				{
					StartupGameConfiguration.Get().level = 2;					
					
					_pageView.hidePage();
					_onPageComplete(button);
					
					break;
				}
					
				case MenuActionList.BACK_LEVEL_BUTTON_CLICKED:
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