package view.menu
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	import view.data.StartupGameConfiguration;
	
	public class MenuPage extends Sprite
	{
		private var _tween:				TweenLite;
		
		private var _resultReceiver:	IMenuPageResultReceiver;
		protected var hash:				StartupGameConfiguration;
		
		private var _onCloseHandler:	Function;
		
		public function MenuPage()
		{
			super();
			
			this.alpha = 0;
			
			onCreate();
		}
		
		
		public function open(resultReceiver:IMenuPageResultReceiver, hash:StartupGameConfiguration):void
		{
			_resultReceiver = resultReceiver;
			this.hash = hash;
			
			_tween = new TweenLite(this, 0.3, {alpha:1, onComplete:handlerOpenPage});
		}
		
		public function close( onCloseHandler:Function ):void
		{
			_onCloseHandler = onCloseHandler;
			
			if(_tween) _tween.kill();
			_tween = new TweenLite(this, 0.3, {alpha:0, onComplete:handlerClosePage});
		}
		
		
		public function get receiver():IMenuPageResultReceiver
		{
			return _resultReceiver;
		}
		
		
		protected function onCreate():void
		{
			
		}
		
		protected function onOpen():void
		{
			
		}
		
		protected function onClose():void
		{
			
		}
		
		
		private function handlerOpenPage():void
		{
			if(_tween) _tween.kill();
			_tween = null;
			
			onOpen();
		}
		
		private function handlerClosePage():void
		{
			if(_tween) _tween.kill();
			_tween = null;
			
			onClose();
			
			if(_onCloseHandler != null) _onCloseHandler(this);
			_onCloseHandler = null;
		}
	}
}