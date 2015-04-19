package main.view.starling
{
	import main.view.IRootLayout;
	import main.view.application.asset.AssetManager;
	import main.view.application.asset.AtlasAsset;
	import main.view.interfaces.IApplicationMenu;
	import main.view.interfaces.game.IMainGameView;
	import main.view.interfaces.preloader.IGamePreloaderScreenView;
	import main.view.starling.game.MainGameView;
	import main.view.starling.menu.sMenuView;
	import main.view.starling.preloader.PreloaderScreen;
	
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	public class sApplicationRootLayout extends Sprite implements IRootLayout
	{
		private var _menuView:			sMenuView;
		private var _gamePreloader:		PreloaderScreen;
		private var _gameView:			MainGameView;
		
		public function sApplicationRootLayout()
		{
			super();
		}
		
		
		public function initialize():void
		{
			loadUIAtlas();
		}
		
		
		public function getMenuView():IApplicationMenu
		{
			if(!_menuView) 
				_menuView = new sMenuView();
			
			return _menuView;
		}		
		
		public function showApplicationMenu():void
		{
			if( !this.contains(_menuView) ) 
				this.addChild(_menuView);
		}
		
		public function hideApplicationMenu():void
		{
			if( this.contains(_menuView) ) 
				this.removeChild(_menuView);
		}
		
		
		public function getMainGameView():IMainGameView
		{
			if( !_gameView ) 
				_gameView = new MainGameView();
			
			if( !this.contains(_gameView) ) 
				this.addChild(_gameView);
			
			return _gameView;
		}
		
		
		
		public function getLoaderScreen():IGamePreloaderScreenView
		{
			if(!_gamePreloader) 
				_gamePreloader = new PreloaderScreen();
			
			if( !this.contains(_gamePreloader) ) 
				this.addChild(_gamePreloader);
			
			return _gamePreloader;
		}
		
		
		public function removeLoaderScreen():void
		{
			if( _gamePreloader && this.contains(_gamePreloader) ) 
				this.removeChild(_gamePreloader);
			
			_gamePreloader.destroy();
			
			_gamePreloader = null;
		}
		
			
		private function loadUIAtlas():void
		{
			var atlasAsset:AtlasAsset = AssetManager.getAtlas("ui_library");
			
			sResourceAsset.loadAtlassFromAsset(atlasAsset);
		}

	}
}