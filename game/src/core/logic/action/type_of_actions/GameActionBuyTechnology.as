package core.logic.action.type_of_actions
{
	import core.logic.action.type_of_actions.interfaces.IGameActionBuyTechnology;

	public class GameActionBuyTechnology extends GameAction implements IGameActionBuyTechnology
	{
		private var _technologyId:	int;
		
		public function GameActionBuyTechnology()
		{
		}
		
		public function get technologyId():int
		{
			return _technologyId;
		}
		
		public function set technologyId(val:int):void
		{
			_technologyId = val;
		}	
	}
}