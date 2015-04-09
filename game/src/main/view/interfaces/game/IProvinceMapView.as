package main.view.interfaces.game
{
	public interface IProvinceMapView extends IMapObject
	{
		
		function setMaskName(maskName:String):void;
		function setX(x:Number):IProvinceMapView;
		function setY(y:Number):IProvinceMapView;
		function setScale(scale:Number):IProvinceMapView;
		
		function setId(id:uint):void;
		
	}
}