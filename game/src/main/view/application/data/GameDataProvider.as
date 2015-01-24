package main.view.application.data
{
	import core.logic.data.StateOfCivilization;
	import core.logic.data.StateOfProvince;
	
	import flash.utils.Dictionary;
	
	import main.data.MapInfo;
	import main.data.ProvinceInfo;

	public class GameDataProvider
	{
		private static var _instance:			GameDataProvider;
		
		private var _mapInfo:			MapInfo;
		private var _civilizationList:	Vector.<StateOfCivilization>;
		
		private var _provinceInfoList:	Dictionary;
		
		private var _userCivilization:	StateOfCivilization;
		
		
		private var _provinceMapInfo:	Dictionary;
		
		public function GameDataProvider()
		{
		}
		
		public static function Get():GameDataProvider
		{
			if(_instance == null) _instance = new GameDataProvider();
			return _instance;
		}
		
		public function initializeCurrentGame( map:MapInfo ):void
		{
			_mapInfo = map;
			
			_provinceInfoList = new Dictionary();
			var v:Vector.<ProvinceInfo> = _mapInfo.provinces;
			
			var i:int;
			for(i = 0; i < v.length; i++)
			{
				_provinceInfoList[v[i].id] = v[i];
			}
		}
		
		
		
		public function setCivilizationList(v:Vector.<StateOfCivilization>, id:int):void
		{
			_civilizationList = v;
			
			var i:int;
			for(i = 0; i < _civilizationList.length; i++)
			{
				if(_civilizationList[i].id == id)
				{
					_userCivilization = _civilizationList[i];
					break;
				}
			}
		}
		
		public function isUserCivilization(id:int):Boolean
		{
			if(_userCivilization.id == id) return true;
			return false;
		}
		
		public function getProvinceInfo(id:int):ProvinceInfo
		{
			return _provinceInfoList[id];
		}
		
		public function getCivilizationByProvinceId(id:int):StateOfCivilization
		{
			var i:int;
			var j:int;
			var provinces:Vector.<StateOfProvince>;
			for(i = 0; i < _civilizationList.length; i++)
			{
				provinces = _civilizationList[i].provinces;
				
				for(j = 0; j < provinces.length; j++) 
				{
					if(provinces[j].id == id)
					{
						return _civilizationList[i];
					}
				}
			}
			
			return null;
		}
		
		public function getStateOfProvince(civilId:int, provinceId:int):StateOfProvince
		{
			var i:int;
			var j:int;
			var provinces:Vector.<StateOfProvince>;
			for(i = 0; i < _civilizationList.length; i++)
			{
				if(civilId == _civilizationList[i].id)
				{
					provinces = _civilizationList[i].provinces;
					
					for(j = 0; j < provinces.length; j++) 
					{
						if(provinces[j].id == provinceId)
						{
							return provinces[j];
						}
					}
				}
			}
			
			return null;
		}
		
		
		
		public function parseGameMapData(data:String):void
		{
			var xml:XML = new XML(data);
			
			_provinceMapInfo = new Dictionary();
			
			var info:ProvinceMapInfo;
			
			var par:String;
			for(par in xml.*) 
			{
				info = new ProvinceMapInfo();
				info.id = uint( xml.*[par].@id );
				info.x = uint( xml.*[par].@x );
				info.y = uint( xml.*[par].@y );
				info.scale = Number( xml.*[par].@scale );
				info.mask = String( xml.*[par].@mask );
				
				_provinceMapInfo[info.id] = info;
			}
		}
		
		public function getProvinceMapInfo(id:uint):ProvinceMapInfo
		{
			return _provinceMapInfo[id];
		}
		
		public function getProvinceMapInfoList():Dictionary
		{
			return _provinceMapInfo;
		}
	}
}