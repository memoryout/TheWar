package view.application
{
	import flash.display.Sprite;
	
	import main.broadcast.Module;
	
	import view.menu.IMenuPageResultReceiver;
	import view.menu.MenuViewStack;
	import view.menu.PageList;
	
	public class ApplicationRootContext extends AppViewContext implements IMenuPageResultReceiver
	{
		private const MODULE_NAME:			String = "view.app.root_context";
		
		private var _canvas:				Sprite;
		private var _menu:					MenuViewStack;
		
		
		public function ApplicationRootContext()
		{
			super();
			
			setSharedModule(MODULE_NAME, this);
		}
		
		
		public function init(canvas:Sprite):void
		{
			_canvas = canvas;
			
			_menu = new MenuViewStack();
			_canvas.addChild( _menu );
			
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
			context.setParentConext( this );
			context.init(_menu, "new_game");
		}
	}
}