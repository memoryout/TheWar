package core.logic.action.type_of_actions.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IGameAction
	{
		function start(price:Number, stepAmount:int):void;
		
		function get type():String;
		
		function get stepsLeft():int;
	}
}