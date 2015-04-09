package main.view.interfaces.game
{
	import main.view.interfaces.IViewObject;

	public interface IMainGameView extends IViewObject
	{
		function getMapView():IMapView;
		function getUIView():IUIGameView;
	}
}