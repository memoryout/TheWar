package utils.updater
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Updater
	{
		private static var _this:				Updater;
		
		private const _listener:		Vector.<Function> = new Vector.<Function>;
		
		private var _currentTime:		Number;
		private var _previousTime:		Number;
		private var _delta:				Number;
		private var _i:					uint;
		
		public function Updater()
		{
			if(!_this) _this = this;
		}
		
		
		public static function get():Updater
		{
			return _this;
		}
		
		
		public function init():void
		{
			_currentTime = _previousTime = new Date().time;
		}
		
		
		public function update():void
		{
			_currentTime = new Date().time;
			_delta = _currentTime - _previousTime;
			
			for(_i = 0; _i < _listener.length; _i++)
			{
				_listener[_i]( _delta );
			}
			
			
			_previousTime = _currentTime;
		}
		
		
		public function addListener(func:Function):void
		{
			var i:int;
			i = _listener.length
			
			while(i--)
			{
				if(_listener[i] == func) return;
			}
			
			_listener.push(func);
		}
		
		
		public function removeListener(func:Function):void
		{
			var i:int;
			i = _listener.length
			
			while(i--)
			{
				if(_listener[i] == func)
				{
					_listener.splice(i, 1);
					return;
				}
			}
		}
	}
}