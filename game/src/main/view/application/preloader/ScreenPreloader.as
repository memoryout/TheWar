package main.view.application.preloader
{
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	
	public class ScreenPreloader extends AppSprite
	{
		private var _loaderInfo:		LoaderInfo;
		
		private var _skin:				MovieClip;
		private var _txt:				TextField;
		
		public function ScreenPreloader()
		{
			super();
		}
		
		public function init():void
		{
			var classRef:Class = AssetManager.getClass("ui","ui.screen.preloader");
			
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				_txt = _skin.getChildByName("txtProgress") as TextField;
				if(_txt)
				{
					_txt.text = "";
				}
				
				_skin.scaleX = _skin.scaleY = AppSprite.getScaleFactor();
			}
		}
		
		public function setLoaderInfo(loaderInfo:LoaderInfo):void
		{
			_loaderInfo = loaderInfo;
			
			_loaderInfo.addEventListener(ProgressEvent.PROGRESS, handlerProgress);
		}
		
		
		private function handlerProgress(e:ProgressEvent):void
		{
			_txt.text = String(e.bytesLoaded/e.bytesTotal); 
		}
		
		
		
		override public function destroy():void
		{
			if(_loaderInfo) _loaderInfo.removeEventListener(ProgressEvent.PROGRESS, handlerProgress);
			
			_loaderInfo = null;
			_skin = null;
			_txt = null;
			
			super.destroy();
		}
	}
}