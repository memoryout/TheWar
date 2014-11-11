package core.logic.action.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IGameAction
	{
		function start(price:Number, stepAmount:int):void;
		
		function get type():String;
		
		function get stepsLeft():int;
	}
}