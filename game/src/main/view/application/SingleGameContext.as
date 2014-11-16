package main.view.application
{
	import core.logic.data.StateOfCivilization;
	import core.logic.events.CoreEvents;
	
	import flash.display.Sprite;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.data.ProvinceInfo;
	import main.view.ViewEvent;
	import main.view.application.data.StartupGameConfiguration;
	import main.view.application.game.GameViewController;
	import main.view.application.menu.IMenuPageResultReceiver;
	import main.view.application.menu.MenuViewStack;
	import main.view.application.menu.PageList;
	
	public class SingleGameContext extends Module implements IMenuPageResultReceiver
	{
		private const MODULE_NAME:		String = "single_game_context";
		
		private var _menu:				MenuViewStack;
		private var _canvas:			Sprite;
		
		private var _gameContext:		GameViewController;
		
		private var _gameConfiguration:StartupGameConfiguration;
		
		public function SingleGameContext()
		{
			super();
			
			this.setSharedModule(MODULE_NAME, this);
		}
		
		
		public function init(menu:MenuViewStack, action:String, canvas:Sprite):void
		{
			_gameConfiguration = new StartupGameConfiguration();
			
			_menu = menu;
			_canvas = canvas;
			
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
		
		private function createGameLayout(civilizations:Vector.<StateOfCivilization>):void
		{
			_menu.showPage(null,null,null);
			_menu.hideBackground();
			
			if(!_gameContext)
			{
				_gameContext = new GameViewController();
				_gameContext.initialize( _canvas, _menu );
				_gameContext.start(civilizations);
			}
		}
		
		override public function receiveMessage(message:MessageData):void
		{
			switch(message.message)
			{
				case CoreEvents.GAME_READY:
				{
					createGameLayout(message.data);
					break;
				}
			}
		}
	}
}