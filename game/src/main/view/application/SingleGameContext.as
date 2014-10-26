package main.view.application
{
	import main.broadcast.Module;
	import main.view.ViewEvent;
	import main.view.application.data.StartupGameConfiguration;
	import main.view.application.menu.IMenuPageResultReceiver;
	import main.view.application.menu.MenuViewStack;
	import main.view.application.menu.PageList;
	
	public class SingleGameContext extends Module implements IMenuPageResultReceiver
	{
		private var _menu:				MenuViewStack;
		
		private var _gameConfiguration:StartupGameConfiguration;
		
		public function SingleGameContext()
		{
			super();
		}
		
		
		public function init(menu:MenuViewStack, action:String):void
		{
			_gameConfiguration = new StartupGameConfiguration();
			
			_menu = menu;
			
			if(action == "new_game")
			{
				_menu.showPage(PageList.SINGLE_GAME_SETTINGS, this, _gameConfiguration);
			}
		}
		
		public function handleMenuPageResult(result:String):void
		{
			switch(result)
			{
				case "start_game":
				{
					sendMessage(ViewEvent.START_SINGLE_GAME, _gameConfiguration);
					break;
				}
			}
		}
	}
}