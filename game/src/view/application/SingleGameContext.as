package view.application
{
	import main.broadcast.Module;
	
	import view.ViewEvent;
	import view.data.StartupGameConfiguration;
	import view.menu.IMenuPageResultReceiver;
	import view.menu.MenuViewStack;
	import view.menu.PageList;
	
	public class SingleGameContext extends AppViewContext implements IMenuPageResultReceiver
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