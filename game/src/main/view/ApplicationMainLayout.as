package main.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import utils.updater.Updater;
	
	public class ApplicationMainLayout extends Sprite
	{
		
		private const _canvas:			Sprite = new Sprite();
		
		private const _updater:			Updater = new Updater();
		
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
			
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
			this.stage.addEventListener(Event.RESIZE, handlerStageResize);
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
				
				
				AppSprite.setScreenSize( new Rectangle(0, 0, screenWidth, screenHeight) );
				
				var canvasWidth:Number = AppDisplaySettings.RESOURCE_WIDTH;
				var canvasHeight:Number = AppDisplaySettings.RESOURCE_HEIGHT;
				
				var scale:Number = screenWidth/AppDisplaySettings.RESOURCE_WIDTH;
				
				canvasHeight = AppDisplaySettings.RESOURCE_HEIGHT * scale;
				if(canvasHeight > screenHeight)
				{
					scale = screenHeight/AppDisplaySettings.RESOURCE_HEIGHT;
				}
				
				var viewport:Rectangle = new Rectangle();
				
				
				canvasWidth = AppDisplaySettings.RESOURCE_WIDTH * scale;
				canvasHeight = AppDisplaySettings.RESOURCE_HEIGHT * scale;
				
				viewport.width = canvasWidth;
				viewport.height = canvasHeight;
				
				viewport.x = /*_canvas.x = */ (screenWidth - canvasWidth) >> 1;
				viewport.y = /*_canvas.y =*/ (screenHeight - canvasHeight) >> 1;
				
				AppSprite.setViewportSize( viewport );
				AppSprite.setScaleFactor( scale );
				
				//_canvas.scaleY = _canvas.scaleX = scale;
				
			}
		}
		
		private function handlerStageResize(e:Event):void
		{
			resizeCanvas();
		}
		
		private function handlerEnterFrame(e:Event):void
		{
			_updater.update();
		}
	}
}