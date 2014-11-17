package core.logic.action
{
	import core.logic.action.interfaces.IGameAction;

	public class GameAction implements IGameAction
	{		
		private var _id:				uint;
		private var _type:				String;
		private var _stepsLeft:			int;
		
		public function GameAction()
		{
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(val:String):void
		{
			_type = val;
		}
		
		public function get stepsLeft():int
		{
			return _stepsLeft;
		}
		
		public function set stepsLeft(val:int):void
		{
			_stepsLeft = val;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(val:int):void
		{
			_id = val;
		}
		
		public function start(price:Number, stepAmount:int):void
		{
			
		}
	}
}