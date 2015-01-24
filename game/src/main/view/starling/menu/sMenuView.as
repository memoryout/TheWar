package main.view.starling.menu
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import main.view.application.asset.AssetManager;
	import main.view.interfaces.IApplicationMenu;
	import main.view.interfaces.menu.IViewMenuStartPage;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class sMenuView extends Sprite implements IApplicationMenu
	{
		private var _onInitializeComplete:		Function;
		
		private var _bgTexture:					Texture;
		private var _background:				Image;
		
		public function sMenuView()
		{
			super();
		}
		
		
		public function initialize(onComplete:Function):void
		{
			_onInitializeComplete = onComplete;
			
			
			var backgroundClass:Class = AssetManager.getClass("ui", "res.ui.splash_bg");
			if(backgroundClass) 
			{
				var bg:BitmapData = new backgroundClass();
				
				var scaleBg:BitmapData = sScreenUtils.scaleResourceBitmapData(bg);
				
				_bgTexture = Texture.fromBitmapData(scaleBg);
				_background = new Image( _bgTexture );
				_background.x = sScreenUtils.getResourceRect().x;
				_background.y = sScreenUtils.getResourceRect().y;
				
				bg.dispose();
				scaleBg.dispose();
			}
			
			if(_onInitializeComplete != null) _onInitializeComplete();
		}
		
		public function showBackground():void
		{
			if(!this.contains(_background)) this.addChildAt(_background, 0);
		}
		
		public function showStartPage():IViewMenuStartPage
		{
			var startPage:sMenuAppStartPage = new sMenuAppStartPage();
			startPage.setLayout( this );
			
			return startPage;
		}
		
		public function unload():void
		{
			if( _background )
			{
				if( this.contains(_background) ) this.removeChild( _background );
				
				_background.dispose();
			}
			
			if(_bgTexture)
			{
				_bgTexture.dispose();
			}
			
			_onInitializeComplete = null;
			_background = null;
			_bgTexture = null;
		}
	}
}