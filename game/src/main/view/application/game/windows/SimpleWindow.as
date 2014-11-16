package main.view.application.game.windows
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import main.view.AppSprite;
	
	public class SimpleWindow extends AppSprite
	{
		private var _tweener:		TweenLite;
		
		public function SimpleWindow()
		{
			super();
			this.alpha = 0;
			this.addEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
		}
		
		
		public function show():void
		{
			if(_tweener) _tweener.kill();
			_tweener = new TweenLite(this, 0.3, {alpha:1, onComplete:onShowComplete} );
		}
		
		public function hide():void
		{
			if(_tweener) _tweener.kill();
			_tweener = new TweenLite(this, 0.3, {alpha:0, onComplete:onHideComplete} );
		}
		
		
		
		
		protected function onCreate():void
		{
			
		}
		
		protected function onHide():void
		{
			
		}
		
		protected function onShow():void
		{
			
		}
		
		
		
		private function handlerAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerAddedToStage);
			onCreate();
		}
		
		private function onShowComplete():void
		{
			onShow();
		}
		
		private function onHideComplete():void
		{
			if(_tweener) _tweener.kill();
			onHide();
		}
	}
}