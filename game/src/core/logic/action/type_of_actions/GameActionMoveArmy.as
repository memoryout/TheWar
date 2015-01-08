package core.logic.action.type_of_actions
{
	import core.logic.action.type_of_actions.interfaces.IGameActionMoveArmy;

	public class GameActionMoveArmy extends GameAction implements IGameActionMoveArmy
	{
		private var _sourceRegionId:int;
		private var _destinationRegionId:int;
		private var _amount:uint;
		
		public function GameActionMoveArmy()
		{
		}
		
		public function get sourceRegionId():int
		{
			return _sourceRegionId;
		}
		
		public function set sourceRegionId(val:int):void
		{
			_sourceRegionId = val;
		}
		
		public function get destinationRegionId():int
		{
			return _destinationRegionId;
		}
		
		public function set destinationRegionId(val:int):void
		{
			_destinationRegionId = val;
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