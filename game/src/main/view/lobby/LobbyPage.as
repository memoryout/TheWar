package main.view.lobby
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	public class LobbyPage extends Sprite
	{
		private static const OPEN_TIME:		Number = 0.3;
		private static const CLOSE_TIME:	Number = 0.3;
		
		private var _onCloseCallback:		Function;
		
		private var _tweener:			TweenLite;
		
		public function LobbyPage()
		{
			super();
			
			this.alpha = 0;
		}
		
		
		public function open():void
		{
			if(_tweener) _tweener.kill();
			_tweener = new TweenLite(this, OPEN_TIME, {alpha:1, onComplete:onOpen});
		}
		
		protected function onOpen():void
		{
			
		}
		
		public function close(onCloseCallback:Function):void
		{
			if(_tweener) _tweener.kill();
			_tweener = new TweenLite(this, OPEN_TIME, {alpha:1, onComplete:onOpen});
		}
		
		protected function onClose():void
		{
			if(_onCloseCallback != null) _onCloseCallback();
			_onCloseCallback = null;
		}
	}
}