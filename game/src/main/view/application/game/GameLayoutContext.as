package main.view.application.game
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import main.broadcast.Module;
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
		
		
		private var _currentStep:		uint;
		
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
			
			
			_currentStep = GameStep.USER_ACTIVITY;
			
			_gameLayout.getHUD().addEventListener(GameHUD.CLICK_ON_NEXT_STEP, handlerUserClickNext);
		}
		
		
		public function start(regions:Vector.<Region>):void
		{
			
		}
		
		
		private function checkCurrentStep():void
		{
			switch(_currentStep)
			{
				case GameStep.USER_ACTIVITY:
				{
					_menuView.hideCurrentPage();
					_gameLayout.getHUD().setUserActivitySkin();
					break;
				}
					
				case GameStep.CIVILIZATION_ORDER:
				{
					_menuView.showPage(PageList.GAME_CIV_ORDER, this, null);
					_gameLayout.getHUD().setGameInfoSkin();
					break;
				}
					
				case GameStep.TREASURE:
				{
					_menuView.showPage(PageList.GAME_TREASURE, this, null);
					_gameLayout.getHUD().setGameInfoSkin();
					break;
				}
					
				case GameStep.STEP_STATISTIC:
				{
					_menuView.showPage(PageList.GAME_STEP_STATISTICS, this, null);
					_gameLayout.getHUD().setGameInfoSkin();
					break;
				}
			}
		}
		
		
		private function handlerUserClickNext(e:Event):void
		{
			switch(_currentStep)
			{
				case GameStep.USER_ACTIVITY:
				{
					// вставь вызов нужного сообщения
					
					_currentStep = GameStep.CIVILIZATION_ORDER;
					checkCurrentStep();
					break;
				}
					
				case GameStep.CIVILIZATION_ORDER:
				{
					// вставь вызов нужного сообщения
					
					_currentStep = GameStep.TREASURE;
					checkCurrentStep();
					break;
				}
					
				case GameStep.TREASURE:
				{
					// вставь вызов нужного сообщения
					
					_currentStep = GameStep.STEP_STATISTIC;
					checkCurrentStep();
					break;
				}
					
				case GameStep.STEP_STATISTIC:
				{
					// вставь вызов нужного сообщения
					
					_currentStep = GameStep.USER_ACTIVITY;
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