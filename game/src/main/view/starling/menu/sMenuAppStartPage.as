package main.view.starling.menu
{
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
		
		public function sMenuAppStartPage()
		{
			
		}
		
		public function initialize(onInitComplete:Function):void
		{
			_initCompleteCallback = onInitComplete;
			
			if(_initCompleteCallback != null) _initCompleteCallback();
			_initCompleteCallback = null;
		}
		
		public function setLayout(layout:Sprite):void
		{
			_layout = layout;
		}
		
		public function showPage():void
		{
			_btnNewGame = new sButtonMenu("menu.start_new_game0000");
			_btnNewGame.createView();
			_btnNewGame.setAction("new_game");
			
			_layout.addEventListener(TouchEvent.TOUCH, handlerTouch);
			
			_layout.addChild( _btnNewGame );
			
			_btnNewGame.x = sScreenUtils.getScreenRect().width - _btnNewGame.width >> 1;
			_btnNewGame.y = sScreenUtils.getScreenRect().height - _btnNewGame.height >> 1;
		}
		
		public function hidePage():void
		{
			if(_layout) 
			{
				_layout.removeEventListener(TouchEvent.TOUCH, handlerTouch);
				
				if(_btnNewGame)
				{
					if( _layout.contains( _btnNewGame) )
					{
						_layout.removeChild( _btnNewGame );
					}
					
					_btnNewGame.destroy();
				}
			}
			
			_btnNewGame = null;
			_layout = null;
		}
		
		private function handlerTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_btnNewGame);
			
			if(touch && touch.phase == TouchPhase.ENDED) 
			{
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.START_NEW_GAME);
			}
		}
	}
}