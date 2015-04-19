package main.view.starling.menu
{
	import com.greensock.TweenLite;
	
	import core.logic.LogicData;
	
	import flash.events.MouseEvent;
	
	import main.data.DataContainer;
	import main.data.MapInfo;
	import main.data.ScenarioInfo;
	import main.view.application.menu.MenuActionList;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.menu.IViewMenuStartPage;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class sMenuNewGamePage implements IViewMenuStartPage
	{
		private var _layout:		starling.display.Sprite;
		
		private var _initCompleteCallback:Function;
		
		private var _btnMap:			sButtonMenu;
		private var _btnCivilization:	sButtonMenu;
		private var _btnEnemies:		sButtonMenu;
		private var _btnLevel:			sButtonMenu;
		private var _btnStartGame:		sButtonMenu;
		private var _btnBack:			sButtonMenu;
		
		private var buttonContainer:Array = new Array();
		
		public function sMenuNewGamePage()
		{
			
		}
		
		public function initialize(onInitComplete:Function):void
		{
			_initCompleteCallback = onInitComplete;
			
			if(_initCompleteCallback != null) 
				_initCompleteCallback();
			
			_initCompleteCallback = null;
		}
		
		public function setLayout(layout:Sprite):void
		{
			_layout = layout;
		}
		
		public function showPage():void
		{
			initVariables();			
			showButtons();
			
			_layout.addEventListener(TouchEvent.TOUCH, handlerTouch);
		}
		
		private function initVariables():void
		{
			var randScenarion:ScenarioInfo = DataContainer.Get().getScenariousList()[(Math.floor(Math.random() * DataContainer.Get().getScenariousList().length))];
			var mapName:String = DataContainer.Get().getMapsList()[randScenarion.mapId].name;
			var civName:String = randScenarion.civilizations[Math.floor(Math.random() * randScenarion.civilizations.length)].name;
			
			addButtons(mapName, civName, randScenarion);
		}
		
		private function addButtons(maName:String, civName:String, scenario:ScenarioInfo):void
		{
			_btnMap = new sButtonMenu("menu.map0000");		
			_btnMap.createView("Map:" + maName);
			_btnMap.setAction("map");
			
			buttonContainer.push(_btnMap);
			
			_layout.addChild( _btnMap );
			
			_btnMap.y = 2*_btnMap.height;
						
			_btnCivilization = new sButtonMenu("menu.civilization0000");
			_btnCivilization.createView("Civiliazation:" + civName);
			_btnCivilization.setAction("civiliazation");
		
			buttonContainer.push(_btnCivilization);
			
			_layout.addChild( _btnCivilization );
			
			_btnCivilization.y = 3.5*_btnCivilization.height;
			
			_btnEnemies = new sButtonMenu("menu.enemies0000");
			_btnEnemies.createView("Enemies:" + scenario.civilizations.length);
			_btnEnemies.setAction("enemies");
			
			buttonContainer.push(_btnEnemies);
			
			_layout.addChild( _btnEnemies );
			
			_btnEnemies.y = 5*_btnEnemies.height;
			
			_btnLevel = new sButtonMenu("menu.level0000");
			_btnLevel.createView("Level:" + getLevelName());
			_btnLevel.setAction("level");
			
			buttonContainer.push(_btnLevel);
			
			_layout.addChild( _btnLevel );
			
			_btnLevel.y = 6.5*_btnLevel.height;
			
			_btnStartGame = new sButtonMenu("menu.start_game0000");
			_btnStartGame.createView("Start Game");
			_btnStartGame.setAction("start_game");
			
			buttonContainer.push(_btnStartGame);
			
			_layout.addChild( _btnStartGame );
			
			_btnStartGame.y = 8*_btnStartGame.height;			
			
			_btnBack = new sButtonMenu("menu.back0000");
			_btnBack.createView("Back");
			_btnBack.setAction("back_game");
			
			buttonContainer.push(_btnBack);
			
			_layout.addChild( _btnBack );
			
			_btnBack.y = 9.5*_btnBack.height;			
		}
		
		private function getLevelName():String
		{
			if(LogicData.Get().gameLevel == 0)
				return "Low";
			
			else if(LogicData.Get().gameLevel == 1)
				return "Middle";
			
			else if(LogicData.Get().gameLevel == 2)
				return "High";				
			
			return "Middle";
		}
		
		private function showButtons():void
		{
			var _delay:Number = 0;
			
			for (var i:int = 0; i < buttonContainer.length; i++) 
			{
				buttonContainer[i].alpha = 0;
				
				TweenLite.to(buttonContainer[i], 0.5, {alpha:1, x:sScreenUtils.getScreenRect().width - buttonContainer[i].width >> 1, delay:_delay});
				
				_delay += 0.1;
			}
		}
		
		public function hidePage():void
		{
			if(_layout) 
			{
				_layout.removeEventListener(TouchEvent.TOUCH, handlerTouch);
				
				for (var i:int = 0; i < buttonContainer.length; i++) 
				{
					if(buttonContainer[i] && _layout.contains( buttonContainer[i]))
					{
						_layout.removeChild( buttonContainer[i] );					
						
						buttonContainer[i].destroy();
						buttonContainer[i] = null;
					}
				}
			}
			
			_layout = null;
		}
		
		private function handlerTouch(e:TouchEvent):void
		{			
			var touch:Touch = e.getTouch(_btnMap);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.MAP_BUTTON_CLICKED);
						
			touch = e.getTouch(_btnCivilization);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.CIVILIZATION_BUTTON_CLICKED);
						
			touch = e.getTouch(_btnEnemies);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.ENEMIES_BUTTON_CLICKED);
			
			touch = e.getTouch(_btnLevel);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.LEVEL_BUTTON_CLICKED);
			
			touch = e.getTouch(_btnStartGame);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.START_GAME_BUTTON_CLICKED);
			
			touch = e.getTouch(_btnBack);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.BACK_GAME_BUTTON_CLICKED);
			
		}
	}
}