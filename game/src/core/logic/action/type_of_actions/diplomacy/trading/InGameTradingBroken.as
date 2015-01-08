package core.logic.action.type_of_actions.diplomacy.trading
{
	import core.logic.action.type_of_actions.interfaces.IInGameTradingBroken;
	import core.logic.action.type_of_actions.GameAction;

	public class InGameTradingBroken extends GameAction implements IInGameTradingBroken
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;		
		
		public function InGameTradingBroken()
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