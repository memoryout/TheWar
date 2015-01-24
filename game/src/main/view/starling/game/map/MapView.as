package main.view.starling.game.map
{
	import main.view.application.asset.AssetManager;
	import main.view.application.asset.AtlasAsset;
	import main.view.interfaces.game.IMapObject;
	import main.view.interfaces.game.IMapView;
	import main.view.interfaces.game.IProvinceMapView;
	import main.view.starling.game.map.province.ProvinceMapView;
	import main.view.starling.sResourceAsset;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class MapView extends Sprite implements IMapView
	{
		private var _onMapLoadComplete:		Function;
		
		private var _mapImage:				Image;
		private var _mapContainer:			Sprite;
		
		
		private var _touchX:				Number;
		private var _touchY:				Number;
		
		private var _mapXDistance:			Number;
		private var _mapYDistance:			Number;
		
		private var _dragAndDropEnabled:	Boolean;
		
		
		private var _mapObjectList:			Vector.<IMapObject>;
		
		public function MapView()
		{
			super();
			
			_mapObjectList = new Vector.<IMapObject>();
		}
		
		public function initialize(onInitComplete:Function):void
		{
			
			_mapXDistance = 0;
			_mapYDistance = 0;
			
			_mapContainer = new Sprite();
			this.addChild( _mapContainer );
			
			
			if(onInitComplete != null) onInitComplete();
			onInitComplete = null;
		}
		
		public function loadMap(onMapLoadComplete:Function):void
		{
			_onMapLoadComplete = onMapLoadComplete;
			
			
			var atlas:AtlasAsset = AssetManager.getAtlas("game_map");
			sResourceAsset.loadAtlassFromAsset(atlas);
			
			var textureAtlas:TextureAtlas = sResourceAsset.getAtlas("game_map");
			
			var texture:Texture = textureAtlas.getTexture("map.jpg");
			
			_mapImage = new Image(texture);
			_mapContainer.addChild( _mapImage );
		}
		
		public function setMoveEnabled(val:Boolean):void
		{
			this.stage.addEventListener(TouchEvent.TOUCH, handlerTouch);
			
			_dragAndDropEnabled = true;
		}
		
		
		public function createProvince():IProvinceMapView
		{
			var province:ProvinceMapView = new ProvinceMapView();
			_mapContainer.addChild(province);
			
			_mapObjectList.push( province );
			
			return province;
		}
		
		private function handlerTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch( this.stage );
			
			if(touch) 
			{
				if(touch.phase == TouchPhase.BEGAN) startMapDragAndDrop(touch.globalX, touch.globalY);
				else if(touch.phase == TouchPhase.MOVED) updateCursorAndMapPosition(touch.globalX, touch.globalY);
				else if(touch.phase == TouchPhase.ENDED) stopMapDragAndDrop();
			}
		}
		
		private function startMapDragAndDrop(tx:Number, ty:Number):void
		{
			_touchX = tx;
			_touchY = ty;
		}
		
		private function updateCursorAndMapPosition(tx:Number, ty:Number):void
		{
			var shiftX:Number = _touchX - tx;
			var shiftY:Number = _touchY - ty;
			
			shiftMapPosition(shiftX, shiftY);
			
			
			_touchX = tx;
			_touchY = ty;
			
		}
		
		private function stopMapDragAndDrop():void
		{
			_dragAndDropEnabled = false;
		}
		
		
		private function shiftMapPosition(sx:Number, sy:Number):void
		{
			var newX:Number = _mapXDistance - sx;
			var newY:Number = _mapYDistance - sy;
			
			if( newX > 0 ) newX = 0;
			else if( newX < sScreenUtils.getScreenRect().width - _mapImage.width ) newX = sScreenUtils.getScreenRect().width - _mapImage.width;
			
			if( newY > 0 ) newY = 0;
			else if( newY < sScreenUtils.getScreenRect().height - _mapImage.height ) newY = sScreenUtils.getScreenRect().height - _mapImage.height;
			
			_mapXDistance = newX;
			_mapYDistance = newY;
			
			_mapContainer.x = newX;
			_mapContainer.y = newY;
		}
	}
}