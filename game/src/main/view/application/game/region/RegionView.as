package main.view.application.game.region
{
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;

	public class RegionView
	{
		private var _area:			MovieClip;
		private var _name:			String;
		
		public function RegionView()
		{
			
		}
		
		public function initialize(area:MovieClip, name:String):void
		{
			_area = area;
			_name = name;
		}
		
		public function setColorFilter(filter:ColorMatrixFilter):void
		{
			_area.filters = [filter];
		}
		
		public function setColor(red:Number, green:Number, blue:Number, alpha:Number = 1):void
		{
			_area.transform.colorTransform = new ColorTransform(red, green, blue, alpha);
		}
	}
}