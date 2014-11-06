package main.view.application.game.region
{
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;

	public class RegionView
	{
		private static const SELECTED_FILTER:GlowFilter = new GlowFilter(0x00ff00, 1, 10, 10, 8);
		private static const NEIGHBOR_FILTER:GlowFilter = new GlowFilter(0xff0000, 1, 10, 10, 8);
		
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
		
		public function select():void
		{
			_area.filters = [SELECTED_FILTER];
		}
		
		public function highlightNeighbor():void
		{
			_area.filters = [NEIGHBOR_FILTER];
		}
		
		public function removeSelection():void
		{
			_area.filters = [];
		}
	}
}