package main.view.application.game.region
{
	import main.view.application.data.ProvinceMapInfo;
	import main.view.interfaces.game.IMapView;
	import main.view.interfaces.game.IProvinceMapView;
	import main.view.starling.sResourceAsset;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class ProvinceController
	{
		private var _mapView:			IMapView;
		private var _provinceMapInfo:	ProvinceMapInfo;
		
		private var _province:			IProvinceMapView;
		
		public function ProvinceController()
		{
			
		}
		
		public function initialize(info:ProvinceMapInfo, mapView:IMapView):void
		{
			_mapView = mapView;
			_provinceMapInfo = info;
			
			createViewInstance();
		}
		
		private function createViewInstance():void
		{
			_province = _mapView.createProvince();
			_province.setMaskName(_provinceMapInfo.mask);
			
			_province.setX(_provinceMapInfo.x)
				.setY(_provinceMapInfo.y)
				.setScale( 1/_provinceMapInfo.scale );
		}
	}
}