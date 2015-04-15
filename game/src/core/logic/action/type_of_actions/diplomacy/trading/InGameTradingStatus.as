package core.logic.action.type_of_actions.diplomacy.trading
{
	import core.logic.action.type_of_actions.interfaces.IInGameTradingStatus;
	import core.logic.action.type_of_actions.GameAction;

	public class InGameTradingStatus extends GameAction implements IInGameTradingStatus
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		private var _union:Boolean;
		
		public function InGameTradingStatus()
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