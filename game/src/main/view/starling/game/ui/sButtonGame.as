package main.view.starling.game.ui
{
	import flash.display.MovieClip;
	
	import main.view.application.asset.AssetManager;
	import main.view.application.asset.AtlasAsset;
	import main.view.starling.sResourceAsset;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class sButtonGame extends Sprite
	{		
		private var _buttonBg:		Image;		
		
		private var _action			:String;
		
		public var overActive		:Boolean;
						
		public function sButtonGame()
		{
			super();
		}
		
		
		public function createView(name:String):void
		{
			var atlas:AtlasAsset = AssetManager.getAtlas("game_ui");
			sResourceAsset.loadAtlassFromAsset(atlas);
			
			var textureAtlas:TextureAtlas = sResourceAsset.getAtlas("game_ui");
			
			var texture:Texture = textureAtlas.getTexture(name);
			
			_buttonBg = new Image(texture);
			this.addChild( _buttonBg );
			
			_buttonBg.scaleX = _buttonBg.scaleY = sScreenUtils.getResourceScaleFactor();
		}
		
		public function setAction(action:String):void
		{
			_action = action;
		}
		
		public function getAction():String
		{
			return _action;
		}		
		
		public function destroy():void
		{
			
		}
	}
}