package main.view.application.menu
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	import main.view.application.data.StartupGameConfiguration;
	
	public class MenuViewStack extends AppSprite
	{
		private var _bg:			Bitmap;
		
		
		private var _currentPage:	MenuPage;
		
		public function MenuViewStack()
		{
			super();
			
			createPageBackground();
		}
		
		
		
		
		public function showPage(pageName:String, resultReceiver:IMenuPageResultReceiver, hash:StartupGameConfiguration):void
		{
			if(_currentPage)
			{
				_currentPage.close( onClosePage );
			}
			
			var classRef:Class = PageList.PAGES[pageName];
			
			if(classRef)
			{
				_currentPage = new classRef();
				_currentPage.open(resultReceiver, hash);
				this.addChild( _currentPage );
			}
		}
		
		
		public function hideBackground():void
		{
			if(_bg && this.contains(_bg) )
			{
				this.removeChild(_bg);
			}
		}
		
		public function hideCurrentPage():void
		{
			if(_currentPage)
			{
				_currentPage.close( onClosePage );
			}
			
			_currentPage = null;
		}
		
		
		private function createPageBackground():void
		{
			var bmdClass:Class = AssetManager.getClass("ui","ui.splash_background");
			
			if( bmdClass )
			{
				var bmd:BitmapData = new bmdClass();
				_bg = new Bitmap(bmd);
				
				this.addChild( _bg );
				
				handlerChanges();
			}
		}
		
		
		private function onClosePage(page:MenuPage):void
		{
			if(this.contains( page ) )
			{
				this.removeChild( page );
			}
		}
		
		
		override public function handlerChanges():void
		{
			if( _bg )
			{
				_bg.x = (AppSprite.getScreenSize().width - _bg.width) >> 1;
				_bg.y = (AppSprite.getScreenSize().height - _bg.height) >> 1;
			}
		}
	}
}