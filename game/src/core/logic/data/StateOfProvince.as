package core.logic.data
{
	public class StateOfProvince
	{
		public var id:					Number = 0;
		public var moneyGrowth:			Number = 0;
		
		public var neighboringRegions:	Array = new Array();
		
		public var buildingList:		Array = new Array();
		
		public var armyNumber:			Number = 0;
		
		public var buildProcess: 		Object = {"current":0, "total":0};
		public var armyProcess: 		Object = {"current":0, "total":0};
		
		public function StateOfProvince()
		{
		}
	}
}