package main.view.application.game.map
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import main.view.application.asset.AssetManager;

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
		
		private var _cachedTiles:		Dictionary;
		
		private var _bitmapMatrix:Vector.<Vector.<Bitmap>>;
		
		private var _tileXNum:			uint;
		private var _tileYNum:			uint;
		
		private var _worldX:			Number;
		private var _worldY:			Number;
		
		private var _totalBitmapWidth:	Number;
		private var _totalBitmapHeight:	Number;
		
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
		
		
		public function loadMap(tileX:uint, tileY:uint, looped:Boolean):void
		{
			_tileXNum = tileX;
			_tileYNum = tileY;
			
			_cachedTiles = new Dictionary();
			
			var i:int;
			var j:int;
			var classRef:Class;
			
			for(i = 0; i < tileX; i++)
			{
				_cachedTiles[i] = new Dictionary();
				
				for(j = 0; j < tileY; j++)
				{
					classRef = AssetManager.getClass("game", "tile_" + i.toString() + "_" + j.toString() );
					
					if(classRef)
					{
						_cachedTiles[i][j] = new classRef();
					}
				}
			}
			
			generateBitmapMatrix();
			
			_worldX = 100;
			_worldY = 780;
			
			renderMap();
			
			_canvas.addEventListener(MouseEvent.MOUSE_DOWN, handlerMouseDown);
			_canvas.addEventListener(MouseEvent.MOUSE_UP, handlerMouseUp);
			_canvas.addEventListener(MouseEvent.MOUSE_MOVE, handlerMoveMove);
			
			freeCamera(true);
			
		}
		
		private function generateBitmapMatrix():void
		{
			if( _cachedTiles[0][0] != null )
			{
				var tileWidth:uint = _cachedTiles[0][0].width;
				var tileHeight:uint = _cachedTiles[0][0].height;
				
				
				var tileXNum:uint = Math.ceil(_viewport.width/tileWidth) + 1;
				var tileYNum:uint = Math.ceil(_viewport.height/tileHeight) + 1;
				
				_bitmapMatrix = new Vector.<Vector.<Bitmap>>();
				
				var i:int;
				var j:int;
				var bm:Bitmap;
				
				for(i = 0; i < tileXNum; i++)
				{
					_bitmapMatrix[i] = new Vector.<Bitmap>;
					
					for(j = 0; j < tileYNum; j++)
					{
						bm = new Bitmap();
						_canvas.addChild(bm);
						bm.x = i * tileWidth;
						bm.y = j * tileHeight;
						
						_bitmapMatrix[i][j] = bm;
						
						bm.bitmapData = _cachedTiles[i][j];
					}
				}
				
				_totalBitmapWidth = (tileXNum) * tileWidth;
				_totalBitmapHeight = (tileYNum) * tileHeight;
			}
			
			this.addEventListener(Event.ENTER_FRAME, handlerFrame);
		}
		
		
		private function renderMap():void
		{
			var i:int, j:int;
			
			var t:Number;
			
			trace("++++++++++++++++++++++++++++++++++++++++");
			for(i = 0; i < _bitmapMatrix.length; i++)
			{
				trace("-------------------------------------");
				
				for(j = 0; j < _bitmapMatrix[i].length; j++)
				{
					t = _worldX + i * _bitmapMatrix[i][j].width;
					
					if(t >= 0) _bitmapMatrix[i][j].x = t % _totalBitmapWidth - _bitmapMatrix[i][j].width;
					else _bitmapMatrix[i][j].x = t % _totalBitmapWidth - _bitmapMatrix[i][j].width + _totalBitmapWidth;
					
					t = _worldY + j * _bitmapMatrix[i][j].height;
					
					if(t >= 0) _bitmapMatrix[i][j].y = t % _totalBitmapHeight - _bitmapMatrix[i][j].height;
					else _bitmapMatrix[i][j].y = t % _totalBitmapHeight - _bitmapMatrix[i][j].height + _totalBitmapHeight;
					
				}
			}
		}
		
		private function handlerFrame(e:Event):void
		{
			//_worldX-= 5;
			//_worldY += 10;
			
			//trace(_worldY)
			//renderMap();
		}
		
		public function setMapSource(map:DisplayObjectContainer):void
		{
			_map = map;
			_canvas.addChild( _map );
			
			
			
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
				_mapStartX = _worldX;
				_mapStartY = _worldY;
				
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
				
				moveCameraToPosition( _mapStartX + deltaX, _mapStartY + deltaY, false);
			}
		}
		
		
		private function moveCameraToPosition(posX:Number, posY:Number, animated:Boolean):void
		{
			_worldX = posX;
			_worldY = posY;
			
			renderMap();
			
			/*if(posX > 0) posX = 0;
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
			*/
		}
	}
}