package main.view.starling.menu
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import main.view.application.asset.AssetManager;
	import main.view.starling.sResourceAsset;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class sButtonMenu extends Sprite
	{
		private var _lable:			String;
		
		private var _upState:		Image;
		private var _downState:		Image;
		private var _labelImage:	Image;
		
		private var _action:		String;
		
		public function sButtonMenu(label_texture:String)
		{
			super();
			
			_lable = label_texture;
		}
		
		
		public function createView():void
		{
			var atlas:TextureAtlas = sResourceAsset.getAtlas("ui_library");
			
			if(atlas) 
			{
				_upState = new Image( atlas.getTexture("button_up.png") );
				_downState = new Image( atlas.getTexture("button_over.png") );
				_labelImage = new Image( atlas.getTexture(_lable) );
				
				_upState.scaleX = _upState.scaleY = sScreenUtils.getResourceScaleFactor();
				_labelImage.scaleX = _labelImage.scaleY = sScreenUtils.getResourceScaleFactor();
				
				this.addChild( _upState );
				this.addChild( _labelImage );
				
				_labelImage.x = _upState.width - _labelImage.width >> 1;
				_labelImage.y = _upState.height - _labelImage.height >> 1;
			}
			
			var classRef:Class = AssetManager.getClass("ui", "res.ui.menu_item");
			if(classRef) 
			{
				var labelMc:MovieClip = new classRef();
				var txt:TextField = labelMc.getChildByName("txt") as TextField;
				if(txt) txt.text = _lable;
			}
		}
		
		public function setAction(action:String):void
		{
			_action = action;
		}
		
		public function destroy():void
		{
			
		}
	}
}