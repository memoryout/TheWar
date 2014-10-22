package main.data
{
	public class DataContainer
	{
		private static const _instance	:DataContainer = new DataContainer();
		
		public var regions:Vector.<Region> = new Vector.<Region>();
		public var scenarios:Vector.<Scenario> = new Vector.<Scenario>();
		
		public function DataContainer()
		{
		}
		
		public static function Get():DataContainer
		{
			return _instance;
		}
		
		public function addRegion(val:Region):void
		{
			regions.push(val);
		}
		
		
		public function addScenario(val:Scenario):void
		{
			scenarios.push(val);
		}			
	}
}