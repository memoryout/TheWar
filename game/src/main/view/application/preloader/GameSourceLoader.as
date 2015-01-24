package main.view.application.preloader
{
	import main.view.IRootLayout;
	import main.view.interfaces.preloader.IGamePreloaderScreenView;
	import main.view.loader.ResourceLoader;
	import main.view.loader.ResourceType;

	public class GameSourceLoader
	{
		private var _rootLayout:			IRootLayout;
		
		private var _preloaderView:			IGamePreloaderScreenView;
		
		private var _resourceLoader:		ResourceLoader;
		
		private var _onSuccess:				Function;
		
		public function GameSourceLoader()
		{
			
		}
		
		public function setOnSuccess(onSuccess:Function):void
		{
			_onSuccess = onSuccess;
		}
		
		public function setLayout(rootLayout:IRootLayout):void
		{
			_rootLayout = rootLayout;
			_preloaderView = _rootLayout.getLoaderScreen();
			_preloaderView.initialize( handlerInitViewLayoutComplete);
		}
		
		private function handlerInitViewLayoutComplete():void
		{
			_resourceLoader = new ResourceLoader();
			_resourceLoader.addToLoadList("data/starling/europe/map.xml", "game_map", ResourceType.ATLAS);
			_resourceLoader.addToLoadList("data/starling/europe/data.xml", "game_map_data", ResourceType.TEXT);
			
			_resourceLoader.startLoad(onResourceLoadComplete, onErrorLoadResource);
		}
		
		private function onResourceLoadComplete():void
		{
			trace("onResourceLoadComplete");
			
			if(_onSuccess != null) _onSuccess();
			_onSuccess = null;
		}
		
		private function onErrorLoadResource():void
		{
			trace("onErrorLoadResource");
		}
		
		public function destroy():void
		{
			_preloaderView.destroy();
			
			_preloaderView = null;
			_rootLayout = null;
			_resourceLoader = null;
		}
	}
}