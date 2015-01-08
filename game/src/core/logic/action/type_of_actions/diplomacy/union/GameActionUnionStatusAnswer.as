package core.logic.action.type_of_actions.diplomacy.union
{
	import core.logic.action.type_of_actions.interfaces.IGameActionUnionStatusAnswer;
	import core.logic.action.type_of_actions.GameAction;

	public class GameActionUnionStatusAnswer extends GameAction implements IGameActionUnionStatusAnswer
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		private var _union:Boolean;
		////////++++++
		public function GameActionUnionStatusAnswer()
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