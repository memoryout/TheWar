package main.view.interfaces.game
{
	import main.view.interfaces.IViewObject;
	
	public interface IMapView extends IViewObject
	{
		function loadMap(onMapLoadComplete:Function):void;
		function setMoveEnabled(enabled:Boolean):void;
		function createProvince():IProvinceMapView;
	}
}