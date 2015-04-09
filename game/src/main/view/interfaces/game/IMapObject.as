package main.view.interfaces.game
{
	import main.view.interfaces.IViewObject;
	
	import starling.events.TouchEvent;

	public interface IMapObject extends IViewObject
	{
		function handleTouchAction(event:TouchEvent):void;
	}
}