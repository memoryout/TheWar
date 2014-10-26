package view.menu
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import view.R;
	import view.data.StartupGameConfiguration;
	
	public class MenuViewStack extends Sprite
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
		
		
		
		private function createPageBackground():void
		{
			var bmdClass:Class = R.getClass("ui.splash_background");
			
			if( bmdClass )
			{
				var bmd:BitmapData = new bmdClass();
				_bg = new Bitmap(bmd);
				
				this.addChild( _bg );
			}
		}
		
		
		private function onClosePage(page:MenuPage):void
		{
			if(this.contains( page ) )
			{
				this.removeChild( page );
			}
		}
	}
}