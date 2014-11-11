package core.logic.action
{
	import core.logic.action.interfaces.IGameActionUnionAnswer;

	public class GameActionUnionAnswer extends GameAction implements IGameActionUnionAnswer
	{		
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		private var _answer:Boolean;
		
		public function GameActionUnionAnswer()
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
		
		public function get answer():Boolean
		{
			return _answer;
		}
		
		public function set answer(val:Boolean):void
		{
			_answer = val;
		}
	}
}