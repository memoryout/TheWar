package core.logic.action.type_of_actions.diplomacy.movement
{
	import core.logic.action.type_of_actions.interfaces.IInGameArmyMovementBroken;
	import core.logic.action.type_of_actions.GameAction;

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