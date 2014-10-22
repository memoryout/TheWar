package core.logic
{
	import main.data.Region;

	public class LogicData
	{
		private static const _instance:		LogicData = new LogicData();
		
		public var selectedScenario:		uint;
		public var selectedCivilization:	uint;
		public var gameLevel:				uint;
		public var randomFill:				Boolean;
		public var randomPlacement:			Boolean;
		
		public var locatedRegions:			Vector.<Region> = new Vector.<Region>();		
		
		public function LogicData()
		{
		}
		
		public static function Get():LogicData
		{
			return _instance;
		}
	}
}