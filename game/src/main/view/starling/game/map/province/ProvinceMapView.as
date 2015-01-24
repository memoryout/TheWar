package main.view.starling.game.map.province
{
	import main.view.interfaces.game.IProvinceMapView;
	import main.view.starling.sResourceAsset;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class ProvinceMapView extends Sprite implements IProvinceMapView
	{
		private var _image:			Image;
		
		public function ProvinceMapView()
		{
			super();
		}
		
		public function initialize(onInitComplete:Function):void
		{
			
			
			if(onInitComplete != null) onInitComplete();
			onInitComplete = null;
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
	}
}