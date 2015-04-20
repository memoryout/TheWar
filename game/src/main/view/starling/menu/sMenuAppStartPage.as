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
	import main.view.starling.menu.simple.sButtonMenu;

	public class sMenuAppStartPage implements IViewMenuStartPage
	{
		private var _layout:		Sprite;
		
		private var _initCompleteCallback:Function;
		
		private var buttonsLable	:Array = ["New Game", "LoadGame", "Scenarios", "Credits"];		
		private var buttonsAction	:Array = ["new_game_action", "load_game_action", "scenarios_action", "credits_action"];				
		
		private var buttonContainer	:Array = new Array();
				
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
			for (var i:int = 0; i < buttonsLable.length; i++) 
			{
				var button:sButtonMenu = new sButtonMenu("");
				button.createView(buttonsLable[i]);
				button.setAction(buttonsAction[i]);
				
				buttonContainer.push(button);
				
				_layout.addChild( button );
				
				button.y =/* 4*button.height + */1.1*i*button.height;
			}
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
					if(buttonContainer[i].getAction() == "new_game_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.NEW_GAME_BUTTON_CLICKED);
						
					else if(buttonContainer[i].getAction() == "load_game_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.LOAD_GAME_BUTTON_CLICKED);
						
					else if(buttonContainer[i].getAction() == "scenarios_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.SCENARIO_BUTTON_CLICKED);
						
					else if(buttonContainer[i].getAction() == "credits_action")
					{
						
					}						
				}
			}
		}
	}
}