package core.logic.action
{
	import core.logic.action.interfaces.IGameActionRequestForUnionStatus;

	public class GameActionRequestForUnionStatus extends GameAction implements IGameActionRequestForUnionStatus
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		private var _union:Boolean;
		
		public function GameActionRequestForUnionStatus()
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
		
		public function get union():Boolean
		{
			return _union;
		}
		
		public function set union(val:Boolean):void
		{
			_union = val;
		}
	}
}