package main.view.application.game.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class MapTile extends Bitmap
	{
		public function MapTile(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}