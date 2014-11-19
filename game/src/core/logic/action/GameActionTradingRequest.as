package core.logic.action
{
	import core.logic.action.interfaces.IGameActionTradingOffer;
	import core.logic.action.interfaces.IGameActionTradingRequest;

	public class GameActionTradingRequest extends GameAction implements IGameActionTradingRequest
	{
		private var _targetCivilizationId:int;
		private var _sourceCivilizationId:int;
		private var _trading:Boolean;
		
		public function GameActionTradingRequest()
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
		
		public function get trading():Boolean
		{
			return _trading;
		}
		
		public function set trading(val:Boolean):void
		{
			_trading = val;
		}
	}
}