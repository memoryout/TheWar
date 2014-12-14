package core.logic.data
{
	import core.logic.TechnologyTree;

	public class StateOfCivilization
	{
		public var id:							Number = 0;
		public var money:						Number = 0;
		
		public var flag:						String;
		public var name:						String;
		
		public var totalBonusFromCrafting:		Number = 0;		
		public var totalBonusFromDiplomacyTrade:Number = 0;		
		
		public var diplomacy:					Diplomacy 	= new Diplomacy();
		public var army:						Army	 	= new Army();
							
		public var provinces:					Vector.<StateOfProvince> = new Vector.<StateOfProvince>();
		
		public var technologyTree:TechnologyTree = new TechnologyTree();
	}
}