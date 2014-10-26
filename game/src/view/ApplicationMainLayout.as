package view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ApplicationMainLayout extends Sprite
	{
		private const _canvas:			Sprite = new Sprite();
		
		public function ApplicationMainLayout()
		{
			super();
			
			_canvas.mouseEnabled = false;
			this.mouseEnabled = false;
			this.addChild( _canvas );
		}
		
		public function initialize():void
		{
			resizeCanvas();
		}
		
		public function get canvas():Sprite
		{
			return _canvas;
		}
		
		
		private function resizeCanvas():void
		{
			if(this.stage)
			{
				var screenWidth:Number = stage.fullScreenWidth;
				var screenHeight:Number = stage.fullScreenHeight;
				
				if( screenWidth < screenHeight )
				{
					screenWidth = stage.fullScreenHeight;
					screenHeight = stage.fullScreenWidth;
				}
				
				var canvasWidth:Number = AppDisplaySettings.RESOURCE_WIDTH;
				var canvasHeight:Number = AppDisplaySettings.RESOURCE_HEIGHT;
				
				var scale:Number = screenWidth/AppDisplaySettings.RESOURCE_WIDTH;
				
				canvasHeight = AppDisplaySettings.RESOURCE_HEIGHT * scale;
				if(canvasHeight > screenHeight)
				{
					scale = screenHeight/AppDisplaySettings.RESOURCE_HEIGHT;
				}
				
				canvasWidth = AppDisplaySettings.RESOURCE_WIDTH * scale;
				canvasHeight = AppDisplaySettings.RESOURCE_HEIGHT * scale;
				
				_canvas.x = (screenWidth - canvasWidth) >> 1;
				_canvas.y = (screenHeight - canvasHeight) >> 1;
				
				_canvas.scaleY = _canvas.scaleX = scale;
				
			}
		}
	}
}