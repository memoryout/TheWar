package main.view.application.game.map
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class MapView extends Sprite
	{
		private var _canvas:			Sprite;
		
		private var _map:				DisplayObjectContainer;
		private var _viewport:			Rectangle;
		
		private var _movable:			Boolean;
		
		private var _isDragged:			Boolean;
		
		
		
		private var _mapStartX:			Number;
		private var _mapStartY:			Number;
		private var _mouseStartX:		Number;
		private var _mouseStartY:		Number;
		
		
		private var _tweener:			TweenLite;
		
		public function MapView()
		{
			initCanvas();
			
			_movable = false;
		}
		
		private function initCanvas():void
		{
			_canvas = new Sprite();
			this.addChild( _canvas );
			
			
			
		}
		
		public function setMapSource(map:DisplayObjectContainer):void
		{
			_map = map;
			_canvas.addChild( _map );
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, handlerMouseDown);
			_canvas.addEventListener(MouseEvent.MOUSE_UP, handlerMouseUp);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, handlerMoveMove);
			
		}
		
		public function get mapInstance():DisplayObjectContainer
		{
			return _map;
		}
		
		public function setViewportSize(rect:Rectangle):void
		{
			_viewport = rect;
		}
		
		
		public function cameraMoveTo():void
		{
			
		}
		
		public function cameraMoveToCenter(animation:Boolean):void
		{
			if(!animation)
			{
				_map.x = (_viewport.width - _map.width ) >> 1 + _viewport.x;
				_map.y = (_viewport.height - _map.height ) >> 1 + _viewport.y;
			}
		}
		
		public function cameraMoveToDown(animation:Boolean):void
		{
			if(!animation)
			{
				moveCameraToPosition(_map.x, _viewport.height - _map.height, false);
			}
			else
			{
				moveCameraToPosition(_map.x, _viewport.height - _map.height, true);
			}
		}
		
		public function scaleTo(value:Number):void
		{
			_map.scaleX = _map.scaleY = value;
		}
		
		public function freeCamera(on:Boolean):void
		{
			_canvas.mouseEnabled = on;
			_movable = on;
		}
		
		
		
		
		private function handlerMouseDown(e:MouseEvent):void
		{
			if(_movable)
			{
				_mapStartX = _map.x;
				_mapStartY = _map.y;
				
				_mouseStartX = _canvas.mouseX;
				_mouseStartY = _canvas.mouseY;
				
				_isDragged = true;
			}
		}
		
		private function handlerMouseUp(e:MouseEvent):void
		{
			_isDragged = false;
		}
		
		private function handlerMoveMove(e:MouseEvent):void
		{
			if(_movable && _isDragged)
			{
				var deltaX:Number = _canvas.mouseX - _mouseStartX;
				var deltaY:Number = _canvas.mouseY - _mouseStartY;
				
				moveCameraToPosition( _mapStartX + deltaX, _mapStartY + deltaY, true);
			}
		}
		
		
		private function moveCameraToPosition(posX:Number, posY:Number, animated:Boolean):void
		{
			if(posX > 0) posX = 0;
			if(posY > 0) posY = 0;
			
			if(posX < _viewport.x + _viewport.width - _map.width ) posX = _viewport.x + _viewport.width - _map.width;
			if(posY < _viewport.y + _viewport.height - _map.height ) posY = _viewport.y + _viewport.height - _map.height;
			
			if(!animated)
			{
				_map.x = posX;
				_map.y = posY;
			}
			else
			{
				if(_tweener) _tweener.kill();
				_tweener = new TweenLite(_map, 0.2, {x:posX, y:posY});
			}
		}
	}
}