package core.logic.action.diplomacy.movement
{
	import core.logic.action.interfaces.IInGameArmyMovementBroken;
	import core.logic.action.GameAction;

	public class InGameArmyMovementBroken extends GameAction implements IInGameArmyMovementBroken
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
				
		public function InGameArmyMovementBroken()
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
	}
}