package main.view.starling.preloader
{
	import flash.display.BitmapData;
	
	import main.view.application.asset.AssetManager;
	import main.view.interfaces.IViewObject;
	import main.view.interfaces.preloader.IGamePreloaderScreenView;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class PreloaderScreen extends Sprite implements IGamePreloaderScreenView
	{
		private var _bgTexture:			Texture;
		private var _background:		Image;
		
		private var _txt:				TextField;
		
		public function PreloaderScreen()
		{
			super();
		}
		
		public function initialize(onInitComplete:Function):void
		{
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
				
				this.addChild( _background );
			}
			
			_txt = new TextField(50, 25, "" );
			this.addChild( _txt );
			
			//_txt.vAlign = VAlign.CENTER;
			_txt.color = 0xffffff;
			//_txt.hAlign = HAlign.CENTER;
			
			setProgress(0);
			
			if(onInitComplete != null) onInitComplete();
			onInitComplete = null;
		}
		
		public function setProgress(progress:Number):void
		{
			_txt.text = progress + "%";
		}
		
		public function setMessage(message:String):void
		{
			
		}
		
		
		public function destroy():void
		{
			if(_background) _background.dispose();
			if(_bgTexture) _bgTexture.dispose();
			if(_txt) _txt.dispose();
			
			_background = null;
			_bgTexture = null;
			_txt = null;
		}
	}
}