package main.view.application.game
{
	import core.logic.LogicData;
	import core.logic.data.StateOfCivilization;
	import core.logic.events.CoreEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.data.Region;
	import main.game.GameStep;
	import main.view.application.menu.IMenuPageResultReceiver;
	import main.view.application.menu.MenuViewStack;
	import main.view.application.menu.PageList;
	
	public class GameLayoutContext extends Module implements IMenuPageResultReceiver
	{
		private const MODULE_NAME:		String = "game_context";
		
		private var _gameLayout:		GameLayout;
		private var _menuView:			MenuViewStack;
				
		public function GameLayoutContext()
		{
			super();
			
			this.setSharedModule(MODULE_NAME, this);
		}
		
		
		public function initialize(layout:Sprite, menu:MenuViewStack):void
		{
			_menuView = menu;
			
			_gameLayout = new GameLayout();
			layout.addChildAt( _gameLayout, 0);
			_gameLayout.load();
			
			checkCurrentStep();
			
			_gameLayout.getHUD().addEventListener(GameHUD.CLICK_ON_NEXT_STEP, handlerUserClickNext);
		}
		
		
		public function start(regions:Vector.<StateOfCivilization>):void
		{
			
		}
		
		
		private function checkCurrentStep():void
		{
			switch(LogicData.Get().currentStep)
			{
				case CoreEvents.USER_ACTIVITY:
				{
					_menuView.hideCurrentPage();
					_gameLayout.getHUD().setUserActivitySkin();
					break;
				}
					
				case CoreEvents.CIVILIZATION_ORDER:
				{
					_menuView.showPage(PageList.GAME_CIV_ORDER, this, null);
					_gameLayout.getHUD().setGameInfoSkin();
					break;
				}
					
				case CoreEvents.TREASURE:
				{
					_menuView.showPage(PageList.GAME_TREASURE, this, null);
					_gameLayout.getHUD().setGameInfoSkin();
					break;
				}
					
				case CoreEvents.STATISTIC:
				{
					_menuView.showPage(PageList.GAME_STEP_STATISTICS, this, null);
					_gameLayout.getHUD().setGameInfoSkin();
					break;
				}
			}
		}
		
		
		private function handlerUserClickNext(e:Event):void
		{			
			switch(LogicData.Get().currentStep)
			{
				case CoreEvents.USER_ACTIVITY:
				{					
					sendMessage(CoreEvents.GET_CIVILIZATION_ORDER, null);			
					
					break;
				}
					
				case CoreEvents.CIVILIZATION_ORDER:
				{
					sendMessage(CoreEvents.GET_TREASURE, null);							
	
					break;
				}
					
				case CoreEvents.TREASURE:
				{
					sendMessage(CoreEvents.GET_STATISTIC, null);								
					
					break;
				}
					
				case CoreEvents.STATISTIC:
				{
					sendMessage(CoreEvents.FINISH_STEP, null);
					checkCurrentStep();		
					
					break;
				}
			}
		}
		
		override public function receiveMessage(message:MessageData):void
		{		
			switch(message.message)
			{
				case CoreEvents.SEND_CIVILIZATION_ORDER:
				{
					checkCurrentStep();
					break;
				}
					
				case CoreEvents.SEND_STATISTIC:
				{
					checkCurrentStep();
					break;
				}
					
				case CoreEvents.SEND_TREASURE:
				{
					checkCurrentStep();
					break;
				}
			}
		}
		
		public function handleMenuPageResult(result:String):void
		{
			
		}
	}
}