package main.view.application.game.map
{
	import flash.utils.Dictionary;
	
	import main.broadcast.Module;
	import main.view.application.ApplicationEvent;
	import main.view.application.data.GameDataProvider;
	import main.view.application.data.ProvinceMapInfo;
	import main.view.application.game.region.ProvinceController;
	import main.view.interfaces.game.IMapView;

	public class MapController extends Module
	{
		private var _mapView:			IMapView;
		
		
		private var _regions:			Vector.<ProvinceController>;
		
		public function MapController()
		{
			super(this);
			
			_regions = new Vector.<ProvinceController>();
		}
		
		public function initialize(mapView:IMapView):void
		{
			_mapView = mapView;
			
			_mapView.initialize( onMapInitComplete);
		}
		
		
		public function createProvinces():void
		{
			var list:Dictionary = GameDataProvider.Get().getProvinceMapInfoList();
			
			var controller:ProvinceController
			
			for each( var province:ProvinceMapInfo in list)
			{
				controller = new ProvinceController();
				controller.initialize( province, _mapView );
				controller.setOnSelect( handleOnSelectProvince );
			}
		}
		
		
		private function onMapInitComplete():void
		{
			_mapView.loadMap(onMapLoaded);
			_mapView.setMoveEnabled(true);
		}
		
		private function onMapLoaded():void
		{
			
		}
		
		
		private function handleOnSelectProvince(id:uint):void
		{
			this.sendMessage(ApplicationEvent.PROVINCE_SELECT, id);
		}
	}
}