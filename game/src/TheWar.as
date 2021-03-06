package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import main.ApplicationModule;
	
	public class TheWar extends Sprite
	{
		private var applicationModule:ApplicationModule;
		
		public function TheWar()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
		}
		
		private function handlerAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handlerApplicationDeactivate);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handlerApplicationActivate);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, handlerApplicationExit);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handlerKeyDown);
			
			applicationModule = new ApplicationModule();
			applicationModule.init(this.stage);
		}
		
		private function handlerApplicationDeactivate(e:Event):void
		{			
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;						
		}
		
		private function handlerApplicationActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;						
		}
		
		
		private function handlerKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.BACK:
				{
					e.preventDefault();
//					ApplicationFacade.getInstance().userPressBack();
					break;
				}
					
				case Keyboard.MENU:
				{
					trace("Keyboard.MENU")
					break;
				}
					
				case Keyboard.SEARCH:
				{
					trace("Keyboard.SEARCH")
					break;
				}
			}
		}
		
		private function handlerApplicationExit(e:Event):void
		{
//			ApplicationFacade.getInstance().applicationClosed();
		}
	}
}