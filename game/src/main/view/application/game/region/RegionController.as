package main.view.application.game.region
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import main.view.application.game.map.MapView;
	import main.view.input.UserInputSystem;

	public class RegionController
	{
		private var _layout:			Sprite;
		
		private const _regionList:		Dictionary = new Dictionary();
		
		public function RegionController()
		{
			
		}
		
		public function setMap(map:MapView):void
		{
			_layout = map.mapInstance as Sprite;
			
			createRegionList();
			
			_layout.addEventListener(MouseEvent.CLICK, handlerClick);
		}
		
		private function createRegionList():void
		{
			var counter:uint = 1;
			var area:MovieClip;
			
			area = _layout.getChildByName("area_" + counter.toString()) as MovieClip;
			
			var region:RegionView;
			
			while(area)
			{
				region = new RegionView();
				region.initialize(area, area.name);
				
				
				_regionList[area.name] = region;
				
				counter ++;
				area = _layout.getChildByName("area_" + counter.toString()) as MovieClip;
			}
		}
		
		public function setColorForRegion(regionId:uint, red:Number, green:Number, blue:Number, alpha:Number):void
		{
			trace("setColorForRegion", _regionList["area_" + regionId.toString()] , regionId)
			if( _regionList["area_" + regionId.toString()] )
			{
				_regionList["area_" + regionId.toString()].setColor(red, green, blue, alpha)
			}
		}
		
		public function resetAllRegions():void
		{
			var par:String;
			for(par in _regionList)
			{
				_regionList[par].setColor(1, 1, 1, 0.5);
			}
		}
		
		
		
		public function highlightRegionLikeSelected(regionId:int):void
		{
			var region:RegionView = _regionList["area_" + regionId.toString()];
			
			if(region) region.select();
		}
		
		public function highlightRegionLikeNeighbor(regionId:int):void
		{
			var region:RegionView = _regionList["area_" + regionId.toString()];
			
			if(region) region.highlightNeighbor();
		}
		
		public function removeSelection():void
		{
			var par:String;
			for(par in _regionList)
			{
				_regionList[par].removeSelection();
			}
		}
		
		private function handlerClick(e:MouseEvent):void
		{
			var name:String = e.target.name;
			
			if( _regionList[name] )
			{
				var arr:Array = name.split("_");
				
				UserInputSystem.get().processAction(MouseEvent.CLICK, "region." + arr[1]);
			}
		}
	}
}