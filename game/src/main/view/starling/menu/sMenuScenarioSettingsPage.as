package main.view.starling.menu
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import main.data.DataContainer;
	import main.data.ScenarioInfo;
	import main.data.StartupGameConfiguration;
	import main.view.application.menu.MenuActionList;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.menu.IViewMenuStartPage;
	import main.view.starling.menu.simple.sButtonMenu;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class sMenuScenarioSettingsPage implements IViewMenuStartPage
	{		
		private var _layout:		starling.display.Sprite;
		
		private var _initCompleteCallback:Function;
		
		private var _btnMyCivilization:	sButtonMenu;
		private var _btnLevel:			sButtonMenu;
		private var _btnStart:			sButtonMenu;
		private var _btnBack:			sButtonMenu;
		
		private var buttonContainer:Array = new Array();
		
		public function sMenuScenarioSettingsPage()
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
			var scenario:ScenarioInfo = DataContainer.Get().getScenariousList()[StartupGameConfiguration.Get().scenario];	
						
			addButtons(scenario.civilizations[(Math.floor(Math.random() * scenario.civilizations.length))].name);
		}
		
		private function addButtons(civName:String):void
		{
			_btnMyCivilization = new sButtonMenu("");		
			_btnMyCivilization.createView(civName);
			_btnMyCivilization.setAction("civ_name");
			
			buttonContainer.push(_btnMyCivilization);
			
			_layout.addChild( _btnMyCivilization );
			
			_btnMyCivilization.y = 2.5*_btnMyCivilization.height;
			
			_btnLevel = new sButtonMenu("");
			_btnLevel.createView("Level:" + getLevelName());
			_btnLevel.setAction("civiliazation");
			
			buttonContainer.push(_btnLevel);
			
			_layout.addChild( _btnLevel );
			
			_btnLevel.y = 4*_btnLevel.height;
			
			_btnStart = new sButtonMenu("");
			_btnStart.createView("Start Game");
			_btnStart.setAction("enemies");
			
			buttonContainer.push(_btnStart);
			
			_layout.addChild( _btnStart );
			
			_btnStart.y = 5.5*_btnStart.height;
						
			_btnBack = new sButtonMenu("");
			_btnBack.createView("Back");
			_btnBack.setAction("back_game");
			
			buttonContainer.push(_btnBack);
			
			_layout.addChild( _btnBack );
			
			_btnBack.y = 7*_btnBack.height;					
		}
		
		private function getLevelName():String
		{
			if(StartupGameConfiguration.Get().level == 0)
				return "Low";
				
			else if(StartupGameConfiguration.Get().level == 1)
				return "Middle";
				
			else if(StartupGameConfiguration.Get().level == 2)
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
			var touch:Touch = e.getTouch(_btnMyCivilization);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.CIV_SETTINGS_BUTTON_CLICKED);
			
			touch = e.getTouch(_btnLevel);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.LEVEL_SETTINGS_BUTTON_CLICKED);
			
			touch = e.getTouch(_btnStart);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.START_SETTINGS_BUTTON_CLICKED);
						
			touch = e.getTouch(_btnBack);
			
			if(touch && touch.phase == TouchPhase.ENDED) 			
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.BACK_SETTINGS_BUTTON_CLICKED);
			
		}
	}
}