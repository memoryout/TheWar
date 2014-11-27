package main.view.application.game
{
	import core.logic.LogicData;
	import core.logic.data.StateOfCivilization;
	import core.logic.events.CoreEvents;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.data.DataContainer;
	import main.data.MapInfo;
	import main.data.ProvinceInfo;
	import main.game.GameStep;
	import main.view.ApplicationMainLayout;
	import main.view.ViewEvent;
	import main.view.application.asset.AssetManager;
	import main.view.application.data.GameDataProvider;
	import main.view.application.game.civilization.CivilizationView;
	import main.view.application.game.windows.action.MakeActionWindowController;
	import main.view.application.menu.IMenuPageResultReceiver;
	import main.view.application.menu.MenuViewStack;
	import main.view.application.menu.PageList;
	import main.view.application.preloader.ScreenPreloader;
	import main.view.input.IInputHandler;
	import main.view.input.UserInputSystem;
	
	public class GameViewController extends Module implements IMenuPageResultReceiver, IInputHandler
	{
		private const MODULE_NAME:		String = "game_context";
		
		private var _gameView:			GameLayout;
		private var _menuView:			MenuViewStack;
		
		private var _civilizations:		Vector.<CivilizationView>;
		
		private var _lastSelectedRegion:int;
		
		private var _provinces:			Vector.<ProvinceInfo>;
		private var _currentMapData:	MapInfo;
		
		private var _rootLayout:		ApplicationMainLayout;
		private var _gameLayout:		Sprite;
		private var _civStateList:		Vector.<StateOfCivilization>;
		
		
		
		private var _preloader:			ScreenPreloader;
				
		public function GameViewController()
		{
			super();
			
			this.setSharedModule(MODULE_NAME, this);
		}
		
		
		public function initialize(rootLayout:ApplicationMainLayout, menu:MenuViewStack, civList:Vector.<StateOfCivilization>):void
		{
			_rootLayout = rootLayout;
			_menuView = menu;
			_gameLayout = _rootLayout.gameLayout;
			_civStateList = civList;
			
			initializeDataProvider();
			
			
		}
		
		
		public function start():void
		{
			loadGameResources();
		}
		
		
		private function initializeDataProvider():void
		{
			
			var map:MapInfo = DataContainer.Get().getMap( LogicData.Get().mapId );
			
			if(map)
			{
				GameDataProvider.Get().initializeCurrentGame( map );
			}
			
						
			GameDataProvider.Get().setCivilizationList(_civStateList, LogicData.Get().selectedCivilization );
		}
		
		private function loadGameResources():void
		{
			var map:MapInfo = DataContainer.Get().getMap( LogicData.Get().mapId );
			
			if(map)
			{
				_preloader = new ScreenPreloader();
				_preloader.init();
				_rootLayout.elementsLayout.addChild( _preloader );
				
				var loaderInfo:LoaderInfo = AssetManager.loadAsset( map.sourceLink, "game");
				_preloader.setLoaderInfo( loaderInfo );
				
				loaderInfo.addEventListener(Event.INIT, handlerResourceLoaded);
				loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoad);				
			}
		}
		
		private function handlerResourceLoaded(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerResourceLoaded);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoad);
			
			buildGameElements();
			
			_rootLayout.elementsLayout.removeChild( _preloader );
			_preloader = null;
		}
		
		private function handlerErrorLoad(e:IOErrorEvent):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerResourceLoaded);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoad);
		}
		
		
		private function buildGameElements():void
		{
			var map:MapInfo = DataContainer.Get().getMap( LogicData.Get().mapId );
			
			_gameView = new GameLayout();
			_gameLayout.addChild( _gameView );
			_gameView.init();
			_gameView.load( map );
			
			_gameView.getHUD().addEventListener(GameHUD.CLICK_ON_NEXT_STEP, handlerUserClickNext);
			
			var civ:CivilizationView;
			var i:int;
			
			_civilizations = new Vector.<CivilizationView>();
			for(i = 0; i < _civStateList.length; i++)
			{
				civ = new CivilizationView();
				civ.initialize(_civStateList[i]);
				_gameView.addCivilization(civ);
				
				_civilizations.push( civ );
			}
			
			checkCurrentStep();
			
			UserInputSystem.get().registerInputActionHandler(this);
		}
		
		private function checkCurrentStep():void
		{
			switch(LogicData.Get().currentStep)
			{
				case CoreEvents.USER_ACTIVITY:
				{
					_menuView.hideCurrentPage();
					_gameView.getHUD().setUserActivitySkin();
					_gameView.getHUD().writeMessage("You turn!");
					break;
				}
					
				case CoreEvents.CIVILIZATION_ORDER:
				{
					_menuView.showPage(PageList.GAME_CIV_ORDER, this, null);
					_gameView.getHUD().setGameInfoSkin();
					break;
				}
					
				case CoreEvents.TREASURE:
				{
					_menuView.showPage(PageList.GAME_TREASURE, this, null);
					_gameView.getHUD().setGameInfoSkin();
					break;
				}
					
				case CoreEvents.STATISTIC:
				{
					_menuView.showPage(PageList.GAME_STEP_STATISTICS, this, null);
					_gameView.getHUD().setGameInfoSkin();
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
					
				case ViewEvent.GET_ACTION_DATA:
				{
					trace("ViewEvent.GET_ACTION_DATA", message.data);
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
			
			_gameView.getHUD().showContextInfo(button);
			
			if(arr.length == 2)
			{
				if(arr[0] == "region")
				{
					userChooseRegion( int(arr[1]) );
				}
				else if(arr[0] == "button")
				{
					processButtonClick(arr[1]);
				}
			}
		}
		
		private function userChooseRegion(provinceId:int):void
		{
			var civ:StateOfCivilization;
			var province:ProvinceInfo;
			
			province = GameDataProvider.Get().getProvinceInfo( provinceId );
			civ = GameDataProvider.Get().getCivilizationByProvinceId( provinceId );
			
			var message:String = "";
			
			if(civ) message += "Civilization: " + civ.name		
			if(province) message += "  Region: " + province.id;
			
			_gameView.getHUD().writeMessage(message);
			
			
			if(civ)
			{
				if(civ.id == 0) // типа моя цивилизация
				{
					_lastSelectedRegion = provinceId;
					_gameView.getRegionController().highlightRegionLikeSelected( provinceId );
					showNeighboors(provinceId);
				}
				else
				{
					if( _lastSelectedRegion > -1 )
					{
						showMoveArmyInterface(provinceId);
						// show how much ui.
					}
					else
					{
						_lastSelectedRegion = -1;
						_gameView.getRegionController().removeSelection();
					}
				}
			}
			else
			{
				if( _lastSelectedRegion > -1 )
				{
					showMoveArmyInterface(provinceId);
					// show how much ui.
				}
				else
				{
					// reset last selected region
					_lastSelectedRegion = -1;
					_gameView.getRegionController().removeSelection();
				}
			}
		}
		
		
		private function showNeighboors(id:int):void
		{
			var i:int;
			var province:ProvinceInfo = GameDataProvider.Get().getProvinceInfo(id);
			
			for(i = 0; i < province.neighboringRegions.length; i++)
			{
				_gameView.getRegionController().highlightRegionLikeNeighbor( province.neighboringRegions[i] );
			}
		}
		
		
		private function showMoveArmyInterface(regionId:int):void
		{
			return;
			
			/*
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
					_gameView.getRegionController().removeSelection();
				}
			}
			else
			{
				_lastSelectedRegion = -1;
				_gameView.getRegionController().removeSelection();
			}
			*/
		}
		
		
		private function processButtonClick(button:String):void
		{
			switch(button)
			{
				case "make_action":
				{
					showMakeActionDialog();
					break;
				}
			}
		}
		
		
		private function showMakeActionDialog():void
		{
			var win:MakeActionWindowController = new MakeActionWindowController();
			_gameView.getWindowLayout().showWindow( win );
		}
	}
}