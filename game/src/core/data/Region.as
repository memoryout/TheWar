package core.data
{
	public class Region
	{
		public var id:				Number = 0;
		public var money:				Number = 0;
		public var growthMoney:			Number = 0;
		
		public var population:			Number = 0;
		public var growthPopulation:	Number = 0;
		
		public var dyplomacy:			Array;
		
		public var army:				Number = 0;
		
		public var civilization:		String = "Empty";
		
		public var buildings:			Object;
		
		public var defence:				Number;
		
		public var neighboringRegions:	Array;
		
		public function Region()
		{
			
		}
	}
}