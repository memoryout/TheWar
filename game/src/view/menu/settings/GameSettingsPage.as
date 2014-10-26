package view.menu.settings
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import view.R;
	import view.menu.MenuPage;
	
	public class GameSettingsPage extends MenuPage
	{
		private var _skin:			MovieClip;
		
		public function GameSettingsPage()
		{
			super();
		}
		
		
		override protected function onCreate():void
		{
			var classRef:Class = R.getClass("ui.menu.game_settings_page");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				var mc:MovieClip = _skin.getChildByName("btStart") as MovieClip;
				
				mc.addEventListener(MouseEvent.CLICK, handlerClickStart);
			}
		}
		
		
		private function handlerClickStart(e:MouseEvent):void
		{
			this.receiver.handleMenuPageResult("start_game");
		}
	}
}