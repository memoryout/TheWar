package main.view.application.menu.enemies
{
	import main.view.application.menu.MenuActionList;
	import main.view.application.menu.interfaces.IMenuPageController;
	import main.view.input.IInputHandler;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.IApplicationMenu;
	import main.view.interfaces.menu.IViewMenuStartPage;
	
	public class EnemiesPageController implements IMenuPageController, IInputHandler
	{
		private var _menu:				IApplicationMenu;
		
		private var _pageView:			IViewMenuStartPage;
		private var _onPageComplete:	Function;
		
		public function EnemiesPageController()
		{
		}
		
		public function initialize(onCompleteCallback:Function):void
		{
			_onPageComplete = onCompleteCallback;
		}
		
		public function setView(menu:IApplicationMenu):void
		{
			_menu = menu;
			
			_pageView = _menu.showEnemiesPage();
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
				case MenuActionList.BACK_ENEMIES_BUTTON_CLICKED:
				{
					_pageView.hidePage();
					_onPageComplete(button);			
					
					break;
				}
				
				/*case MenuActionList.ENEMIES_ITEM_BUTTON_CLICKED:
				{
					_pageView.hidePage();
					_onPageComplete(button);			
					
					break;
				}	*/			
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