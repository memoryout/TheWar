package main.data
{
	public class DataContainer
	{
		private static const _instance	:DataContainer = new DataContainer();
		
		private var maps:Vector.<MapInfo> 	 			= new Vector.<MapInfo>();
		private var scenarios:Vector.<ScenarioInfo> 	= new Vector.<ScenarioInfo>();
		
		public function DataContainer()
		{
		}
		
		public static function Get():DataContainer
		{
			return _instance;
		}
		
		public function addMap(val:MapInfo):void
		{
			maps.push(val);
		}
		
		
		public function addScenario(val:ScenarioInfo):void
		{
			scenarios.push(val);
		}	
		
		public function getScenariousList():Vector.<ScenarioInfo>
		{
			return scenarios;
		}
		
		public function getMapsList():Vector.<MapInfo>
		{
			return maps;
		}
	}
}