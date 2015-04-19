package main.data
{
	import core.logic.data.TechnologieInfo;

	public class DataContainer
	{
		private static const _instance	:DataContainer = new DataContainer();
		
		private var maps:Vector.<MapInfo> 	 				= new Vector.<MapInfo>();
		private var scenarios:Vector.<ScenarioInfo> 		= new Vector.<ScenarioInfo>();
		private var technologies:Vector.<TechnologieInfo> 	= new Vector.<TechnologieInfo>();
		private var civilization:Vector.<CivilizationInfo>	= new Vector.<CivilizationInfo>();		
		
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
		
		public function addTechnologie(val:TechnologieInfo):void
		{
			technologies.push(val);
		}	
		
		public function getTechnologiesList():Vector.<TechnologieInfo>
		{
			return technologies;
		}
		
		public function getMapsList():Vector.<MapInfo>
		{
			return maps;
		}
		
		public function addCivilization(val:CivilizationInfo):void
		{
			civilization.push(val);
		}	
		
		public function getCivilizationList():Vector.<CivilizationInfo>
		{
			return civilization;
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