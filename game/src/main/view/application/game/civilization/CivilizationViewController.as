package main.view.application.game.civilization
{
	import core.logic.data.StateOfCivilization;
	
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	
	import main.view.application.game.region.RegionController;
	import main.view.application.game.region.RegionView;

	public class CivilizationViewController
	{
		
		private const COLOR_R:		uint = uint(Math.random() * 0xff);
		private const COLOR_G:		uint = uint(Math.random() * 0xff);
		private const COLOR_B:		uint = uint(Math.random() * 0xff);
		
		private const _occupiedTerritories:			Vector.<int> = new Vector.<int>();
		
		private var _regionController:		RegionController;
		
		private var _data:			StateOfCivilization;
		
		public function CivilizationViewController()
		{
			
		}
		
		public function initialize(data:StateOfCivilization, region:RegionController):void
		{
			_data = data;
			
			_regionController = region;
			
			var i:int;
			for(i = 0; i < data.regions.length; i++)
			{
				_occupiedTerritories.push(data.regions[i]);
			}
			
			colorizeTerritories();
		}
		
		private function colorizeTerritories():void
		{
			var i:int;
			for(i = 0; i < _occupiedTerritories.length; i++)
			{
				_regionController.setColorForRegion(_occupiedTerritories[i], COLOR_R/0xff, COLOR_G/0xff, COLOR_B/0xff, 1)
			}
		}
	}
}