package main.boot.task
{
	public interface ISimpleTask
	{
		function run(...args):void;
		function addListener(event:uint, listener:Function):void;
		function removeListener(event:uint, listener:Function):void;
		function dispachLocalEvent(event:uint, data:* = null):void;
		function destroy():void;
	}
}