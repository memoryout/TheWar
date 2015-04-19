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
	
	public class sMenuLevelPage implements IViewMenuStartPage
	{
		private var _layout:		starling.display.Sprite;
		
		private var _initCompleteCallback:Function;
		
		private var _btnLow:		sButtonMenu;
		private var _btnMiddle:		sButtonMenu;
		private var _btnHigh:		sButtonMenu;
		
		
		private var buttonContainer:Array = new Array();
		
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
			_btnLow = new sButtonMenu("");
			_btnLow.createView("Low");
			_btnLow.setAction("low_level");
			
			buttonContainer.push(_btnLow);
			
			_layout.addChild( _btnLow );
			_btnLow.y = 4*_btnLow.height;
			
			_btnMiddle = new sButtonMenu("");
			_btnMiddle.createView("Middle");
			_btnMiddle.setAction("middle_level");
			
			buttonContainer.push(_btnMiddle);
			
			_layout.addChild( _btnMiddle );
			
			_btnMiddle.y = 5.5*_btnMiddle.height;
			
			_btnHigh = new sButtonMenu("");
			_btnHigh.createView("High");
			_btnHigh.setAction("high_level");
			
			buttonContainer.push(_btnHigh);
			
			
			_layout.addChild(_btnHigh);
			
			_btnHigh.y = 7*_btnHigh.height;
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
			var touch:Touch = e.getTouch(_btnLow);
			
			if(touch && touch.phase == TouchPhase.ENDED) 
			{
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.LOW_LEVEL_BUTTON_CLICKED);
			}
			
			touch = e.getTouch(_btnMiddle);
			
			if(touch && touch.phase == TouchPhase.ENDED) 
			{
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.MIDDLE_LEVEL_BUTTON_CLICKED);
			}
			
			touch = e.getTouch(_btnHigh);
			
			if(touch && touch.phase == TouchPhase.ENDED) 
			{
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.HIGH_LEVEL_BUTTON_CLICKED);
			}
		}
	}
}