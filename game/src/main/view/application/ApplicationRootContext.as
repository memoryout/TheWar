package main.view.application
{
	import flash.display.Sprite;
	
	import main.broadcast.Module;
	import main.view.ApplicationMainLayout;
	import main.view.application.menu.IMenuPageResultReceiver;
	import main.view.application.menu.MenuViewStack;
	import main.view.application.menu.PageList;
	
	public class ApplicationRootContext extends Module implements IMenuPageResultReceiver
	{
		private const MODULE_NAME:			String = "view.app.root_context";
		
		private var _rootLayout:			ApplicationMainLayout;
		private var _canvas:				Sprite;
		private var _menu:					MenuViewStack;
		
		
		public function ApplicationRootContext()
		{
			super();
			
			setSharedModule(MODULE_NAME, this);
		}
		
		
		public function init(rootLayout:ApplicationMainLayout):void
		{
			_rootLayout = rootLayout;
			
			_canvas = rootLayout.canvas;
			
			_menu = new MenuViewStack();
			_rootLayout.menuLayout.addChild( _menu );
			
			createStartPage();
		}
		
		
		public function handleMenuPageResult(result:String):void
		{
			switch(result)
			{
				case "new_game":
				{
					createSingleGameContext();
					break;
				}
			}
		}
		
		
		private function createStartPage():void
		{
			_menu.showPage(PageList.START_PAGE, this, null);
		}
		
		
		private function createSingleGameContext():void
		{
			var context:SingleGameContext = new SingleGameContext();
			context.init(_menu, "new_game", _rootLayout );
		}
	}
}