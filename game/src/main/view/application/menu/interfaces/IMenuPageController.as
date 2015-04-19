package main.view.application.menu.interfaces
{
	import main.view.interfaces.IApplicationMenu;

	public interface IMenuPageController
	{
		function initialize(onCompleteCallback:Function):void;
		function setView(menu:IApplicationMenu):void;
		function destroy():void;
	}
}