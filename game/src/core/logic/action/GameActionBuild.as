package core.logic.action
{
	import core.logic.action.interfaces.IGameActionBuild;

	public class GameActionBuild extends GameAction implements IGameActionBuild
	{
		private var _destinationRegionId:	int;
		private var _buildingId:			int;
		
		public function GameActionBuild()
		{
		}
		
		public function get destinationRegionId():int
		{
			return _destinationRegionId;
		}
		
		public function set destinationRegionId(val:int):void
		{
			_destinationRegionId = val;
		}	
		
		public function get buildingId():int
		{
			return _buildingId;
		}
		
		public function set buildingId(val:int):void
		{
			_buildingId = val;
		}	
	}
}