package main.view.starling.menu
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import main.view.application.menu.MenuActionList;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.menu.IViewMenuStartPage;
	import main.view.starling.menu.simple.sButtonMenu;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class sMenuLevelPage implements IViewMenuStartPage
	{
		private var _layout:		Sprite;
		
		private var _initCompleteCallback:Function;
		
		private var buttonsLable	:Array = ["Low", "Middle", "High", "Back"];		
		private var buttonsAction	:Array = ["low_level_action", "middle_level_action", "high_level_action", "back_level_action"];				
		private var buttonContainer	:Array = new Array();
		
		public function sMenuLevelPage()
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
		
		private function addButtons():void
		{
			for (var i:int = 0; i < buttonsLable.length; i++) 
			{
				var button:sButtonMenu = new sButtonMenu("");
				button.createView(buttonsLable[i]);
				button.setAction(buttonsAction[i]);
				
				buttonContainer.push(button);
				
				_layout.addChild( button );
				
				button.y = 4*button.height + 1.1*i*button.height;
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
		
		private function handlerTouch(e:TouchEvent):void
		{
			for (var i:int = 0; i < buttonContainer.length; i++) 
			{
				var touch:Touch = e.getTouch(buttonContainer[i]);
			
				if(touch && touch.phase == TouchPhase.ENDED) 
				{
					if(buttonContainer[i].getAction() == "low_level_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.LOW_LEVEL_BUTTON_CLICKED);
					
					else if(buttonContainer[i].getAction() == "middle_level_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.MIDDLE_LEVEL_BUTTON_CLICKED);
					
					else if(buttonContainer[i].getAction() == "high_level_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.HIGH_LEVEL_BUTTON_CLICKED);
					
					else if(buttonContainer[i].getAction() == "back_level_action")
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.BACK_LEVEL_BUTTON_CLICKED);
				}
			}
		}
	}
}