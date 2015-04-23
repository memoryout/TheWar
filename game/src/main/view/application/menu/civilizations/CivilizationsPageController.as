package main.view.application.menu.civilizations
{
	import main.view.application.menu.MenuActionList;
	import main.view.application.menu.interfaces.IMenuPageController;
	import main.view.input.IInputHandler;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.IApplicationMenu;
	import main.view.interfaces.menu.IViewMenuStartPage;
	
	public class CivilizationsPageController implements IMenuPageController, IInputHandler
	{
		private var _menu:				IApplicationMenu;
		
		private var _pageView:			IViewMenuStartPage;
		private var _onPageComplete:	Function;
		
		public function CivilizationsPageController()
		{
		}
		
		public function initialize(onCompleteCallback:Function):void
		{
			_onPageComplete = onCompleteCallback;
		}
		
		public function setView(menu:IApplicationMenu):void
		{
			_menu = menu;
			
			_pageView = _menu.showCivilizationsPage();
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
				case MenuActionList.BACK_CIV_BUTTON_CLICKED:
				case MenuActionList.CIVILIZATION_ITEM_BUTTON_CLICKED:
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