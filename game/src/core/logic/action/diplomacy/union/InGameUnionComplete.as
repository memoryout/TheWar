package core.logic.action.diplomacy.union
{
	import core.logic.action.interfaces.IInGameUnionComplete;
	import core.logic.action.GameAction;

	public class InGameUnionComplete extends GameAction implements IInGameUnionComplete
	{		
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
				
		public function InGameUnionComplete()
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