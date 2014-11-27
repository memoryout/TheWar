package main.view.application.game
{
	import core.logic.data.StateOfCivilization;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import main.data.MapInfo;
	import main.view.AppSprite;
	import main.view.ApplicationMainLayout;
	import main.view.application.asset.AssetManager;
	import main.view.application.game.civilization.CivilizationView;
	import main.view.application.game.map.MapView;
	import main.view.application.game.region.RegionController;
	import main.view.application.game.region.RegionView;
	import main.view.application.game.windows.GameWindowLayout;
	import main.view.input.UserInputSystem;
	
	public class GameLayout extends Sprite
	{
		private var _skin:				MovieClip;
		
		private var _hudSkin:			MovieClip;
		private var _hud:				GameHUD;
		
		private const _regions:			Dictionary = new Dictionary();
		
		private const _civilization:	Dictionary = new Dictionary();
		
		private var _mapView:			MapView;
		private var _regionController:	RegionController;
		
		private var _windowLayout:		GameWindowLayout;
		
		private var _map:				MapInfo;
		
		public function GameLayout()
		{
			super();
		}
		
		public function init():void
		{
			_mapView = new MapView();
			
			_mapView.setViewportSize( AppSprite.getViewportSize() );
			
			this.addChild( _mapView );
		}
		
		
		public function load( map:MapInfo ):void
		{
			_map = map;
			
			_mapView.loadMap(map.tileXNum, map.tileXNum, true);
			
			/*var classRef:Class = AssetManager.getClass("ui","game.map_01");
			
			if(classRef)
			{
				var map:MovieClip = new classRef();
				_mapView.setMapSource( map );
				_mapView.scaleTo(0.5);
				_mapView.cameraMoveToCenter(false);
				_mapView.cameraMoveToDown(false);
				_mapView.freeCamera(true);
				
				_regionController = new RegionController();
				_regionController.setMap( _mapView );
				_regionController.resetAllRegions();
			}*/
			
			_hud = new GameHUD();
			_hud.initialize();
			this.addChild(_hud);
			
			_windowLayout = new GameWindowLayout();
			this.addChild( _windowLayout );
		}
		
		
		public function addCivilization(civ:CivilizationView):void
		{
			//civ.setRegionController(_regionController);
		}
		
		public function getHUD():GameHUD
		{
			return _hud;
		}
		
		public function getWindowLayout():GameWindowLayout
		{
			return _windowLayout;
		}
		
		public function getRegionController():RegionController
		{
			return _regionController;
		}
	}
}