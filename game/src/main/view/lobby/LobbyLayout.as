package main.view.lobby
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import main.view.R;
	
	public class LobbyLayout extends Sprite
	{
		private var _bg:			Bitmap;
		
		public function LobbyLayout()
		{
			super();
		}
		
		public function init():void
		{
			var classRef:Class = R.getClass("ui.splash_background");
			if(classRef)
			{
				var bmd:BitmapData = new classRef();
				_bg = new Bitmap(bmd);
				this.addChild( _bg );
			}
		}
	}
}