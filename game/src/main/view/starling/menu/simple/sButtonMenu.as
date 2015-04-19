package main.view.starling.menu.simple
{
	import flash.display.MovieClip;
	
	import main.view.application.asset.AssetManager;
	import main.view.starling.sResourceAsset;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class sButtonMenu extends Sprite
	{
		private var _lable:			String;
		
		private var _upState:		Image;
		private var _downState:		Image;
		private var _labelImage:	Image;
		
		private var _action			:String;
		
		private var txt				:TextField;
		
		private var overActive		:Boolean;
		
		public function sButtonMenu(label_texture:String)
		{
			super();
			
			_lable = label_texture;
		}
		
		
		public function createView(name:String):void
		{
			var atlas:TextureAtlas = sResourceAsset.getAtlas("ui_library");
			
			if(atlas) 
			{
				_upState = new Image( atlas.getTexture("button_up.png") );
				_downState = new Image( atlas.getTexture("button_over.png") );
//				_labelImage = new Image( atlas.getTexture(_lable) );
								
				txt = new TextField(528, 76.7, "hhh");
				
				txt.color		= 0xFFFFFF;
				txt.fontSize	= 60;
				txt.fontName	= "CenturyGothic";
//				txt.autoScale = true;
				txt.autoSize = "center";
								
				txt.text = name;
				
				_upState.scaleX 	= _upState.scaleY 		= sScreenUtils.getResourceScaleFactor();
//				_labelImage.scaleX 	= _labelImage.scaleY 	= sScreenUtils.getResourceScaleFactor();
				txt.scaleX 			= txt.scaleY 		= sScreenUtils.getResourceScaleFactor();
				
				this.addChild( _upState );
//				this.addChild( _labelImage );
				this.addChild(txt);
											
				txt.x = /*_labelImage.x =*/ _upState.width - txt.width >> 1;
				txt.y = /*_labelImage.y =*/ _upState.height - txt.height >> 1;				
			}
			
			/*var classRef:Class = AssetManager.getClass("ui", "res.ui.menu_item");
			
			if(classRef) 
			{
				var labelMc:MovieClip = new classRef();
				var txt:TextField = labelMc.getChildByName("txt") as TextField;
				
				if(txt)
					txt.text = _lable;
			}*/
		}
		
		public function overState():void
		{
			this.addChildAt(_downState, 0);
			
			_downState.scaleX = _downState.scaleY = sScreenUtils.getResourceScaleFactor();
			
			if(_upState && this.contains(_upState))
				this.removeChild(_upState);
			
			overActive = true;
		}
		
		public function outState():void
		{
			if(!overActive)
				return;
			
			this.addChildAt(_upState, 0);
			
			_upState.scaleX = _upState.scaleY = sScreenUtils.getResourceScaleFactor();
			
			if(_downState && this.contains(_downState))
				this.removeChild(_downState);
			
			overActive = false;
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