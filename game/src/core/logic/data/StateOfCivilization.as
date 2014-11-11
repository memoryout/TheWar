package core.logic.data
{
	public class StateOfCivilization
	{
		public var id:							Number = 0;
		public var money:						Number = 0;
		
		public var flag:						String;
		public var name:						String;
		
		public var totalBonusFromCrafting:		Number = 0;		
		public var totalBonusFromDiplomacyTrade:Number = 0;
				
		public var militaryCraft:				Array 		= new Array();
		public var economicCraft:				Array 		= new Array();		
		
		public var diplomacy:					Diplomacy 	= new Diplomacy();
		public var army:						Army	 	= new Army();
							
		public var provinces:					Vector.<StateOfProvince> = new Vector.<StateOfProvince>();
	}
}