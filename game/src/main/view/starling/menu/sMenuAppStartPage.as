package main.view.starling.menu
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import main.view.application.menu.MenuActionList;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.menu.IViewMenuStartPage;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class sMenuAppStartPage implements IViewMenuStartPage
	{
		private var _layout:		Sprite;
		
		private var _initCompleteCallback:Function;

		private var _btnNewGame:	sButtonMenu;
		private var _btnLoadGame:	sButtonMenu;
		private var _btnScenarious:	sButtonMenu;
		private var _btnCredits:	sButtonMenu;
		
		private var buttonContainer:Array = new Array();
		
		public function sMenuAppStartPage()
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
			addButtons();
			showButtons();
			
			_layout.addEventListener(TouchEvent.TOUCH, handlerTouch);
		}
		
		private function addButtons():void
		{
			_btnNewGame = new sButtonMenu("menu.start_new_game0000");
			_btnNewGame.createView("New Game");
			_btnNewGame.setAction("new_game");
			
			buttonContainer.push(_btnNewGame);
			
			_layout.addChild( _btnNewGame );
			
			//			_btnNewGame.x = sScreenUtils.getScreenRect().width - _btnNewGame.width >> 1;
			_btnNewGame.y = 4*_btnNewGame.height;
			
			_btnLoadGame = new sButtonMenu("menu.load_game0000");
			_btnLoadGame.createView("Load Game");
			_btnLoadGame.setAction("load_game");
			
			buttonContainer.push(_btnLoadGame);
			
			_layout.addChild( _btnLoadGame );
			
			//			_btnLoadGame.x = sScreenUtils.getScreenRect().width - _btnLoadGame.width >> 1;
			_btnLoadGame.y = 5.5*_btnNewGame.height;
			
			_btnScenarious = new sButtonMenu("menu.scenarios0000");
			_btnScenarious.createView("Scenarios");
			_btnScenarious.setAction("scenarios_game");
			
			buttonContainer.push(_btnScenarious);

			
			_layout.addChild( _btnScenarious );
			
			//			_btnScenarious.x = sScreenUtils.getScreenRect().width - _btnScenarious.width >> 1;
			_btnScenarious.y = 7*_btnNewGame.height;
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
			var touch:Touch = e.getTouch(_btnNewGame);
			
			if(touch) 
			{
				if( touch.phase == TouchPhase.ENDED)
					UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.NEW_GAME_BUTTON_CLICKED);
				
				else if(touch.phase == TouchPhase.HOVER)				
					_btnNewGame.overState();
			}
			
			touch = e.getTouch(_btnLoadGame);
			
			if(touch && touch.phase == TouchPhase.ENDED) 
			{
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.LOAD_GAME_BUTTON_CLICKED);
			}
			
			touch = e.getTouch(_btnScenarious);
			
			if(touch && touch.phase == TouchPhase.ENDED) 
			{
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.SCENARIO_BUTTON_CLICKED);
			}
		}
	}
}