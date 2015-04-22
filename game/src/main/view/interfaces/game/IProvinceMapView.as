package main.view.interfaces.game
{
	public interface IProvinceMapView extends IMapObject
	{
		
		function setMaskName(maskName:String):void;
		function setX(x:Number):IProvinceMapView;
		function setY(y:Number):IProvinceMapView;
		function setScale(scale:Number):IProvinceMapView;
		
		function setId(id:uint):void;
		
		function setProvinceDefaultColor(color:uint):void;
		function resetProvinceColorSettings():void;
		function set selected(b:Boolean):void
		
	}
}