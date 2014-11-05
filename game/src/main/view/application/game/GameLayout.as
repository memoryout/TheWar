package main.view.application.game
{
	import core.logic.data.StateOfCivilization;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import main.view.ApplicationMainLayout;
	import main.view.R;
	import main.view.application.game.civilization.CivilizationViewController;
	import main.view.application.game.map.MapView;
	import main.view.application.game.region.RegionController;
	import main.view.application.game.region.RegionView;
	import main.view.input.UserInputSystem;
	
	public class GameLayout extends Sprite
	{
		private var _skin:			MovieClip;
		
		private var _hudSkin:		MovieClip;
		private var _hud:			GameHUD;
		
		private const _regions:		Dictionary = new Dictionary();
		
		private const _civilization:Dictionary = new Dictionary();
		
		private var _mapView:			MapView;
		private var _regionController:	RegionController;
		
		public function GameLayout()
		{
			super();
		}
		
		public function init():void
		{
			_mapView = new MapView();
			
			_mapView.setViewportSize( ApplicationMainLayout.getViewportRect() );
			
			this.addChild( _mapView );
		}
		
		
		public function load():void
		{
			var classRef:Class = R.getClass("game.map_01");
			
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
			}
			
			_hud = new GameHUD();
			_hud.initialize();
			this.addChild(_hud);
		}
		
		
		public function createCivilization(data:StateOfCivilization):void
		{
			if( _civilization[data.id] ) return;
			
			var civ:CivilizationViewController = new CivilizationViewController();
			civ.initialize(data, _regionController);
		}
		
		public function getHUD():GameHUD
		{
			return _hud;
		}
	}
}