package core.logic
{
	import core.logic.data.CivilizationInListOfOrder;
	import core.logic.data.StateOfCivilization;
	
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
		
		public var civilizationList:		Vector.<StateOfCivilization> = new Vector.<StateOfCivilization>();		
		
		public var listOfOrder:				Vector.<CivilizationInListOfOrder> = new Vector.<CivilizationInListOfOrder>();		
		
		public var currentStep:				String =  "user_activity";		
		
		public function LogicData()
		{
		}
		
		public static function Get():LogicData
		{
			return _instance;
		}
	}
}