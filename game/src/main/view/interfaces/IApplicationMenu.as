package main.view.interfaces
{
	import main.view.interfaces.menu.IViewMenuStartPage;

	public interface IApplicationMenu
	{
		function initialize(onComplete:Function):void;
		function showBackground():void;
		function unload():void;
		
		function showStartPage():IViewMenuStartPage;
		
	}
}