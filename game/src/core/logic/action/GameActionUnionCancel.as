package core.logic.action
{
	import core.logic.action.interfaces.IGameActionUnionCancel;

	public class GameActionUnionCancel  extends GameAction implements IGameActionUnionCancel
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		
		public function GameActionUnionCancel()
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