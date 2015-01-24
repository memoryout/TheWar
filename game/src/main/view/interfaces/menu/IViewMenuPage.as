package main.view.interfaces.menu
{
	import main.view.interfaces.IViewObject;

	public interface IViewMenuPage extends IViewObject
	{
		function showPage():void;
		function hidePage():void;
	}
}