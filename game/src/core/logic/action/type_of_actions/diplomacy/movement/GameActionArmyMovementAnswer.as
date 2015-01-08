package core.logic.action.type_of_actions.diplomacy.movement
{
	import core.logic.action.type_of_actions.interfaces.IGameActionArmyMovementAnswer;
	import core.logic.action.type_of_actions.GameAction;

	public class GameActionArmyMovementAnswer extends GameAction implements IGameActionArmyMovementAnswer
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		private var _accepted:Boolean;
		//////++
		public function GameActionArmyMovementAnswer()
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