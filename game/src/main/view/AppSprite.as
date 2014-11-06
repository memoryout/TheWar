package main.view
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import utils.updater.Updater;
	
	public class AppSprite extends Sprite
	{
		private static const _spriteList:		Vector.<AppSprite> = new Vector.<AppSprite>();
		
		private static var SCALE_FACTOR:		Number = 1;
		private static var SCREEN_RECT:			Rectangle;
		private static var VIEWPORT_RECT:		Rectangle;
		
		
		
		
		public static function setScaleFactor(value:Number):void
		{
			SCALE_FACTOR = value;
			updateChanges();
		}
		
		public static function setScreenSize(rect:Rectangle):void
		{
			SCREEN_RECT = rect;
			updateChanges();
		}
		
		public static function setViewportSize(rect:Rectangle):void
		{
			VIEWPORT_RECT = rect;
			updateChanges();
		}
		
		public static function getScaleFactor():Number
		{
			return SCALE_FACTOR;
		}
		
		public static function getScreenSize():Rectangle
		{
			return SCREEN_RECT;
		}
		
		public static function getViewportSize():Rectangle
		{
			return VIEWPORT_RECT;
		}
		
		
		private static function updateChanges():void
		{
			var i:int;
			for(i = 0; i < _spriteList.length; i++)
			{
				_spriteList[i].handlerChanges();
			}
		}
		
		
		
		
		
		public function AppSprite()
		{
			super();
			
			_spriteList.push( this );
		}
		
		
		
		
		
		public function destroy():void
		{
			var i:int;
			for(i = 0; i < _spriteList.length; i++)
			{
				if( _spriteList[i] == this )
				{
					_spriteList.splice(i, 1);
					break;
				}
			}
		}
		
		
		protected function listenOnEnterFrame():void
		{
			Updater.get().addListener( handlerOnEnterFrame );
		}
		
		protected function removeOnEnterFrameListener():void
		{
			Updater.get().removeListener( handlerOnEnterFrame );
		}
		
		
		
		public function handlerOnEnterFrame():void
		{
			
		}
		
		public function handlerChanges():void
		{
			
		}
	}
}