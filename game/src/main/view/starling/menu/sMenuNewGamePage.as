package main.view.starling.menu
{
	import com.greensock.TweenLite;
	
	import core.logic.LogicData;
	
	import flash.events.MouseEvent;
	
	import main.data.DataContainer;
	import main.data.MapInfo;
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

	public class sMenuNewGamePage implements IViewMenuStartPage
	{
		private var _layout:		starling.display.Sprite;
		
		private var _initCompleteCallback:Function;
				
		private var buttonsLable	:Array = [];		
		private var buttonsAction	:Array = [];				
		private var buttonContainer	:Array = new Array();
		
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
			addButtons();
			showButtons();
			
			_layout.addEventListener(TouchEvent.TOUCH, handlerTouch);
		}
		
		private function initVariables():void
		{				
			buttonsLable.push("Map:" + StartupGameConfiguration.Get().mapName);
			buttonsAction.push("map_new_game_action");
			
			buttonsLable.push("Civiliazation:" + StartupGameConfiguration.Get().civilizationName);
			buttonsAction.push("civ_new_game_action");
			
			buttonsLable.push("Enemies:" + StartupGameConfiguration.Get().enemies);
			buttonsAction.push("enemies_new_game_action");
			
			buttonsLable.push("Level:" + getLevelName());
			buttonsAction.push("level_new_game_action");
			
			buttonsLable.push("Start Game");
			buttonsAction.push("start_new_game_action");
			
			buttonsLable.push("Back");
			buttonsAction.push("back_new_game_action");
		}
		
		private function addButtons():void
		{
			for (var i:int = 0; i < buttonsLable.length; i++) 
			{
				var button:sButtonMenu = new sButtonMenu("");
				button.createView(buttonsLable[i]);
				button.setAction(buttonsAction[i]);
				
				buttonContainer.push(button);
				
				_layout.addChild( button );
				
				button.y = /*4*button.height + */ 1.1*i*button.height;
			}
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
			for (var i:int = 0; i < buttonContainer.length; i++) 
			{
				var touch:Touch = e.getTouch(buttonContainer[i]);
				if(touch && touch.phase == TouchPhase.ENDED) 
				{
					if(buttonContainer[i].getAction() == "map_new_game_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.MAP_BUTTON_CLICKED);
						
					else if(buttonContainer[i].getAction() == "civ_new_game_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.CIVILIZATION_BUTTON_CLICKED);
						
					else if(buttonContainer[i].getAction() == "enemies_new_game_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.ENEMIES_BUTTON_CLICKED);
						
					else if(buttonContainer[i].getAction() == "level_new_game_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.LEVEL_BUTTON_CLICKED);
					
					else if(buttonContainer[i].getAction() == "start_new_game_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.START_GAME_BUTTON_CLICKED);
					
					else if(buttonContainer[i].getAction() == "back_new_game_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.BACK_NEW_BUTTON_CLICKED);
				}
			}			
		}
	}
}