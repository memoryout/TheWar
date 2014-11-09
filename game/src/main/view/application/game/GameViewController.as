package main.view.application.game
{
	import core.logic.LogicData;
	import core.logic.data.StateOfCivilization;
	import core.logic.events.CoreEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.data.DataContainer;
	import main.data.MapInfo;
	import main.data.ProvinceInfo;
	import main.game.GameStep;
	import main.view.application.game.civilization.CivilizationView;
	import main.view.application.menu.IMenuPageResultReceiver;
	import main.view.application.menu.MenuViewStack;
	import main.view.application.menu.PageList;
	import main.view.input.IInputHandler;
	import main.view.input.UserInputSystem;
	
	public class GameViewController extends Module implements IMenuPageResultReceiver, IInputHandler
	{
		private const MODULE_NAME:		String = "game_context";
		
		private var _gameLayout:		GameLayout;
		private var _menuView:			MenuViewStack;
		
		private var _civilizations:		Vector.<CivilizationView>;
		
		private var _lastSelectedRegion:int;
		
		private var _provinces:			Vector.<ProvinceInfo>;
				
		public function GameViewController()
		{
			super();
			
			this.setSharedModule(MODULE_NAME, this);
		}
		
		
		public function initialize(layout:Sprite, menu:MenuViewStack):void
		{
			_menuView = menu;
			
			_gameLayout = new GameLayout();
			layout.addChildAt( _gameLayout, 0);
			_gameLayout.init();
			_gameLayout.load();
			
			checkCurrentStep();
			
			_gameLayout.getHUD().addEventListener(GameHUD.CLICK_ON_NEXT_STEP, handlerUserClickNext);
			
			_lastSelectedRegion = -1;
			
			var maps:Vector.<MapInfo> = DataContainer.Get().getMapsList();
			
			var i:int;
			for(i = 0; i < maps.length; i++)
			{
				if(maps[i].id == 0)
				{
					_provinces = maps[i].provinces;
				}
			}
		}
		
		
		public function start(civList:Vector.<StateOfCivilization>):void
		{
			var i:int;
			var civ:CivilizationView;
			_civilizations = new Vector.<CivilizationView>();
			for(i = 0; i < civList.length; i++)
			{
				civ = new CivilizationView();
				civ.initialize(civList[i]);
				_gameLayout.addCivilization(civ);
				
				_civilizations.push( civ );
			}
			
			UserInputSystem.get().registerInputActionHandler(this);
		}
		
		
		private function checkCurrentStep():void
		{
			switch(LogicData.Get().currentStep)
			{
				case CoreEvents.USER_ACTIVITY:
				{
					_menuView.hideCurrentPage();
					_gameLayout.getHUD().setUserActivitySkin();
					_gameLayout.getHUD().writeMessage("You turn!");
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
		
		
		public function handlerInputAction(type:String, button:String):void
		{
			switch(type)
			{
				case MouseEvent.CLICK:
				{
					processClick(button);
					break;
				}
			}
			
			trace(type, button);
		}
		
		private function processClick(button:String):void
		{
			var arr:Array = button.split(".");
			
			if(arr.length == 2)
			{
				if(arr[0] == "region")
				{
					userChooseRegion( int(arr[1]) );
				}
			}
		}
		
		private function userChooseRegion(regionId:int):void
		{
			
			var regions:Vector.<ProvinceInfo> = _provinces;
			var i:int;
			var civ:CivilizationView;
			var region:ProvinceInfo;
			
			for(i = 0; i < regions.length; i++)
			{
				if(regions[i].id == regionId)
				{
					region = regions[i];
					break;
				}
			}
			
			
			for(i = 0; i < _civilizations.length; i++)
			{
				if(_civilizations[i].hasRegion(regionId) ) 
				{
					civ = _civilizations[i];
					break;
				}
			}
			
			var message:String = "";
			
			if(civ) message += "Civilization: " + civ.getStateInfo().name;			
			if(region) message += "  Region: " + region.id;
			
			_gameLayout.getHUD().writeMessage(message);
			
			
			if(civ)
			{
				if(civ.getStateInfo().id == 0) // типа моя цивилизация
				{
					_lastSelectedRegion = regionId;
					_gameLayout.getRegionController().highlightRegionLikeSelected( regionId );
					showNeighboors(regionId);
				}
				else
				{
					if( _lastSelectedRegion > -1 )
					{
						showMoveArmyInterface(regionId);
						// show how much ui.
					}
					else
					{
						_lastSelectedRegion = -1;
						_gameLayout.getRegionController().removeSelection();
					}
				}
			}
			else
			{
				if( _lastSelectedRegion > -1 )
				{
					showMoveArmyInterface(regionId);
					// show how much ui.
				}
				else
				{
					// reset last selected region
					_lastSelectedRegion = -1;
					_gameLayout.getRegionController().removeSelection();
				}
			}
		}
		
		
		private function showNeighboors(regionId:int):void
		{
			var regions:Vector.<ProvinceInfo> = _provinces;
			var i:int;
			var region:ProvinceInfo;
			
			for(i = 0; i < regions.length; i++)
			{
				if(regions[i].id == regionId)
				{
					region = regions[i];
					break;
				}
			}
			
			for(i = 0; i < region.neighboringRegions.length; i++)
			{
				_gameLayout.getRegionController().highlightRegionLikeNeighbor( region.neighboringRegions[i] );
			}
		}
		
		
		private function showMoveArmyInterface(regionId:int):void
		{
			var regions:Vector.<ProvinceInfo> = _provinces;
			var i:int;
			var region:ProvinceInfo;
			var civ:CivilizationView;
			
			
			for(i = 0; i < _civilizations.length; i++)
			{
				if(_civilizations[i].getStateInfo().id == 0 ) 
				{
					civ = _civilizations[i];
					break;
				}
			}
			
			
			for(i = 0; i < regions.length; i++)
			{
				if(regions[i].id == _lastSelectedRegion)
				{
					region = regions[i];
					break;
				}
			}
			
			if(civ && region)
			{
				if( region.neighboringRegions.indexOf(regionId.toString()) != -1)
				{
					trace("show ui");
				}
				else
				{
					_lastSelectedRegion = -1;
					_gameLayout.getRegionController().removeSelection();
				}
			}
			else
			{
				_lastSelectedRegion = -1;
				_gameLayout.getRegionController().removeSelection();
			}
			
		}
	}
}