package main.view.application.menu.start
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import main.view.R;
	import main.view.application.menu.MenuPage;
	
	public class StartPageMenu extends MenuPage
	{
		private var _skin:			MovieClip;
		
		public function StartPageMenu()
		{
			super();
		}
		
		override protected function onCreate():void
		{
			var classRef:Class = R.getClass("ui.menu.start_page");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				
				var mc:MovieClip = _skin.getChildByName("btNewGame") as MovieClip;
				mc.addEventListener(MouseEvent.CLICK, handlerClickNewGame);
			}
		}
		
		
		private function handlerClickNewGame(e:MouseEvent):void
		{
			this.receiver.handleMenuPageResult("new_game");
		}
	}
}