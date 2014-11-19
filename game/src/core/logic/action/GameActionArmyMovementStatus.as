package core.logic.action
{
	import core.logic.action.interfaces.IGameActionArmyMovementStatus;

	public class GameActionArmyMovementStatus extends GameAction implements IGameActionArmyMovementStatus
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		private var _accepted:Boolean;
		
		public function GameActionArmyMovementStatus()
		{
		}
		
		public function get targetCivilizationId():int
		{
			return _targetCivilizationId;
		}
		
		public function set targetCivilizationId(val:int):void
		{
			_targetCivilizationId = val;
		}
		
		public function get sourceCivilizationId():int
		{
			return _sourceCivilizationId;
		}
		
		public function set sourceCivilizationId(val:int):void
		{
			_sourceCivilizationId = val;
		}
		
		public function get accepted():Boolean
		{
			return _accepted;
		}
		
		public function set accepted(val:Boolean):void
		{
			_accepted = val;
		}	
	}
}