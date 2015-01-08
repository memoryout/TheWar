package core.logic.action.type_of_actions.diplomacy.movement
{
	import core.logic.action.type_of_actions.GameAction;
	import core.logic.action.type_of_actions.interfaces.IInGameArmyMovementComplete;

	public class InGameArmyMovementComplete extends GameAction implements IInGameArmyMovementComplete
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		
		public function InGameArmyMovementComplete()
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