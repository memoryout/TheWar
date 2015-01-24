package main.view.starling
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import main.view.AppDisplaySettings;
	
	import starling.textures.Texture;

	public class sScreenUtils
	{
		private static const _resourceRect:			Rectangle = new Rectangle();
		private static const _screenRect:			Rectangle = new Rectangle();
		
		private static var _resourceScaleFactor:	Number;
		
		
		public static function calculateResourceSize(stage:Stage):void
		{
			_screenRect.width = stage.fullScreenWidth;
			_screenRect.height = stage.fullScreenHeight; 
			
			if(_screenRect.width < _screenRect.height) 
			{
				_screenRect.x = _screenRect.width;
				_screenRect.width = _screenRect.height;
				_screenRect.height = _screenRect.x;
				_screenRect.x = 0;
			}
			
			var canvasWidth:Number = AppDisplaySettings.RESOURCE_WIDTH;
			var canvasHeight:Number = AppDisplaySettings.RESOURCE_HEIGHT;
			
			var scale:Number = _screenRect.width/AppDisplaySettings.RESOURCE_WIDTH;
			
			canvasHeight = AppDisplaySettings.RESOURCE_HEIGHT * scale;
			if(canvasHeight > _screenRect.height)
			{
				scale = _screenRect.height/AppDisplaySettings.RESOURCE_HEIGHT;
			}
			
			_resourceScaleFactor = scale;
			
			canvasWidth = AppDisplaySettings.RESOURCE_WIDTH * scale;
			canvasHeight = AppDisplaySettings.RESOURCE_HEIGHT * scale;
			
			_resourceRect.width = canvasWidth;
			_resourceRect.height = canvasHeight;
			
			_resourceRect.x = (_screenRect.width - canvasWidth) >> 1;
			_resourceRect.y = (_screenRect.height - canvasHeight) >> 1;
		}
		
		public static function getResourceRect():Rectangle
		{
			return _resourceRect;
		}
		
		public static function getScreenRect():Rectangle
		{
			return _screenRect;
		}
		
		public static function getResourceScaleFactor():Number
		{
			return _resourceScaleFactor;
		}
		
		public static function scaleResourceBitmapData(bmd:BitmapData):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(_resourceScaleFactor, _resourceScaleFactor);
			
			
			var result:BitmapData = new BitmapData(bmd.width * _resourceScaleFactor, bmd.height * _resourceScaleFactor, bmd.transparent, 0xffffffff);
			result.draw(bmd, matrix);
			
			return result;
		}
		
	}
}