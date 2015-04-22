package main.view.starling.game.map.province
{
	import flash.events.MouseEvent;
	
	import main.view.application.game.GameActionList;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.game.IProvinceMapView;
	import main.view.starling.sResourceAsset;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class ProvinceMapView extends Sprite implements IProvinceMapView
	{
		private var _image:			Image;
		private var _id:			uint;
		
		private var _defaultColor:	uint;
		private var _currentColor:	uint;
		
		public function ProvinceMapView()
		{
			super();
		}
		
		public function initialize(onInitComplete:Function):void
		{
			
			
			if(onInitComplete != null) onInitComplete();
			onInitComplete = null;
		}
		
		public function setId(id:uint):void
		{
			_id = id;
		}
		
		public function setMaskName(maskName:String):void
		{
			var textureAtlas:TextureAtlas = sResourceAsset.getAtlas("game_map");
			
			var texture:Texture = textureAtlas.getTexture(maskName);
			
			_image = new Image(texture);
			this.addChild(_image);
		}
		
		public function setX(x:Number):IProvinceMapView
		{
			this.x = x;
			return this;
		}
		
		public function setY(y:Number):IProvinceMapView
		{
			this.y = y;
			return this;
		}
		
		public function setScale(scale:Number):IProvinceMapView
		{
			this.scaleX = this.scaleY = scale;
			return this;
		}
		
		
		public function handleTouchAction(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			
			if(touch)
				trace(touch.phase);
			
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				UserInputSystem.get().processAction(MouseEvent.CLICK, GameActionList.SELECT_REGION + "." + _id.toString() );
			}
		}
		
		
		public function resetProvinceColorSettings():void
		{
			_image.alpha = 0;
			_image.color = 0xffffff;
		}
		
		public function setProvinceDefaultColor(color:uint):void
		{
			_defaultColor = _currentColor = color;
			
			_image.alpha = 0.3;
			_image.color = _currentColor;
		}
		
		
		public function set selected(b:Boolean):void
		{
			if(b)
				_currentColor = _defaultColor | 0x555555;
			else 
				_currentColor = _defaultColor;
			
			updateColor();
		}
		
		
		private function updateColor():void
		{
			_image.color = _currentColor;
		}
	}
}