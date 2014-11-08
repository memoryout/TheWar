package core.logic.data
{
	public class StateOfCivilization
	{
		public var id:				Number = 0;
		public var money:			Number = 0;
		
		public var flag:			String;
		public var name:			String;
		
		public var totalBonusFromCrafting:	Number = 0;
		
		public var craftTree:		Array = new Array();
		
		public var provinces:		Vector.<StateOfProvince> = new Vector.<StateOfProvince>();
	}
}