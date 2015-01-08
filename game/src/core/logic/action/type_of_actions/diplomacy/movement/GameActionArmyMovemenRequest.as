package core.logic.action.type_of_actions.diplomacy.movement
{
	import core.logic.action.type_of_actions.interfaces.IGameActionArmyMovemenRequest;
	import core.logic.action.type_of_actions.GameAction;

	public class GameActionArmyMovemenRequest extends GameAction implements IGameActionArmyMovemenRequest
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		private var _accepted:Boolean;
		///++
		public function GameActionArmyMovemenRequest()
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