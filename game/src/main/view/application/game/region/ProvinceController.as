package main.view.application.game.region
{
	import flash.events.MouseEvent;
	
	import main.view.application.data.ProvinceMapInfo;
	import main.view.application.game.GameActionList;
	import main.view.input.IInputHandler;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.game.IMapView;
	import main.view.interfaces.game.IProvinceMapView;
	import main.view.starling.sResourceAsset;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class ProvinceController implements IInputHandler
	{
		private var _mapView:			IMapView;
		private var _provinceMapInfo:	ProvinceMapInfo;
		
		private var _province:			IProvinceMapView;
		
		private var _onSelectCallback:	Function;
		
		private var _selected:			Boolean;
		
		public function ProvinceController()
		{
			
		}
		
		public function initialize(info:ProvinceMapInfo, mapView:IMapView):void
		{
			_mapView = mapView;
			_provinceMapInfo = info;
			
			createViewInstance();
			
			UserInputSystem.get().registerInputActionHandler(this);
		}
		
		public function setOnSelect(onSelectHandler:Function):void
		{
			_onSelectCallback = onSelectHandler;
		}
		
		private function createViewInstance():void
		{
			_province = _mapView.createProvince();
			_province.setMaskName(_provinceMapInfo.mask);
			_province.setId(_provinceMapInfo.id);
			_province.setProvinceDefaultColor( 0xff0000 );
			
			_province.setX(_provinceMapInfo.x)
				.setY(_provinceMapInfo.y)
				.setScale( 1/_provinceMapInfo.scale );

		}
		
		private function onTouchProvince():void
		{
			
		}
		
		public function handlerInputAction(type:String, button:String):void
		{
			if(type == MouseEvent.CLICK && button == GameActionList.SELECT_REGION + "." + _provinceMapInfo.id.toString() )
			{
				_onSelectCallback( _provinceMapInfo.id );
				_province.selected = true;
				_selected = true;
			}
			else
			{
				if(_selected)
				{
					_selected = false;
					_province.selected = false;
				}
			}
		}
	}
}