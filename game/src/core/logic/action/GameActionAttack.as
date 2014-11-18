package core.logic.action
{
	import core.logic.action.interfaces.IGameActionAttack;

	public class GameActionAttack extends GameAction implements IGameActionAttack
	{
		private var _sourceRegionId:int;
		private var _destinationRegionId:int;
		private var _amount:Number;
		private var _win:Boolean;
		
		public function GameActionAttack()
		{
		}
		
		public function get sourceRegionId():int
		{
			return _sourceRegionId;
		}
		
		public function set sourceRegionId(val:int):void
		{
			_sourceRegionId = val;
		}
		
		public function get destinationRegionId():int
		{
			return _destinationRegionId;
		}
		
		public function set destinationRegionId(val:int):void
		{
			_destinationRegionId = val;
		}
		
		public function get amount():Number
		{
			return _amount;
		}
		
		public function set amount(val:Number):void
		{
			_amount = val;
		}
		
		public function get win():Boolean
		{
			return _win;
		}
		
		public function set win(val:Boolean):void
		{
			_win = val;
		}
	}
}