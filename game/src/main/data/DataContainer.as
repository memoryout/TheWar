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
		
		public function getScenario(id:uint):ScenarioInfo
		{
			var i:int;
			for(i = 0; i < scenarios.length; i++)
			{
				if( scenarios[i].id == id ) return scenarios[i];
			}
			
			return null;
		}
		
		public function getMap(id:uint):MapInfo
		{
			var i:int;
			for(i = 0; i < maps.length; i++)
			{
				if( maps[i].id == id ) return maps[i];
			}
			
			return null;
		}
	}
}