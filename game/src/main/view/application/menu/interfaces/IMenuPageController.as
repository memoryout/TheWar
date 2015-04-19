package main.view.application.menu.interfaces
{
	import main.view.application.data.StartupGameConfiguration;
	import main.view.interfaces.IApplicationMenu;

	public interface IMenuPageController
	{
		function initialize(data:StartupGameConfiguration, onCompleteCallback:Function):void;
		function setView(menu:IApplicationMenu):void;
		function destroy():void;
	}
}