package core.logic.action.type_of_actions.diplomacy.union
{
	import core.logic.action.type_of_actions.interfaces.IGameActionUnionCancel;
	import core.logic.action.type_of_actions.GameAction;

	public class GameActionUnionStatusBroken  extends GameAction implements IGameActionUnionCancel
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		///////////++++++++
		public function GameActionUnionStatusBroken()
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