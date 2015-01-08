package core.logic.action.type_of_actions{		import core.logic.action.type_of_actions.interfaces.IGameActionByArmy;

	public class GameActionByArmy extends GameAction implements IGameActionByArmy
	{
		private var _sourceRegionID:	int;
		private var _amount:			int;				
		public function GameActionByArmy()
		{
		}
		
		public function get sourceRegionID():int
		{
			return _sourceRegionID;
		}
		
		public function set sourceRegionID(val:int):void
		{
			_sourceRegionID = val;
		}	
		
		public function get amount():uint
		{
			return _amount;
		}
		
		public function set amount(val:uint):void
		{
			_amount = val;
		}		
	}
}