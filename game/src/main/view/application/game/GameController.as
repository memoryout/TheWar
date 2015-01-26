package main.view.application.game
{
	import core.logic.LogicData;
	
	import main.broadcast.Module;
	import main.data.DataContainer;
	import main.data.MapInfo;
	import main.view.IRootLayout;
	import main.view.application.asset.AssetManager;
	import main.view.application.data.GameDataProvider;
	import main.view.application.game.map.MapController;
	import main.view.interfaces.game.IMainGameView;
	
	public class GameController extends Module
	{
		public static const MODULE_NAME:	String = "app.game_controller";
		
		private var _rootLayout:	IRootLayout;
		
		private var _mapController:	MapController;
		
		private var _gameView:		IMainGameView;
		
		public function GameController()
		{
			super(this);
		}
		
		public function initialize(layout:IRootLayout):void
		{
			_rootLayout = layout;
			
			loadData();
			
			initGameView();	
		}
		
		private function loadData():void
		{
			var map:MapInfo = DataContainer.Get().getMap( LogicData.Get().mapId );
			if(map) GameDataProvider.Get().initializeCurrentGame( map );
			
			GameDataProvider.Get().setCivilizationList(LogicData.Get().civilizationList, LogicData.Get().selectedCivilization );
			
			var mapInfo:String = AssetManager.getText("game_map_data");
			
			GameDataProvider.Get().parseGameMapData(mapInfo);
			
			
		}
		
		private function initGameView():void
		{
			_gameView = _rootLayout.getMainGameView();
			_gameView.initialize( onGameViewInitComplete);
		}
		
		private function onGameViewInitComplete():void
		{
			buildComponents();
			
			_mapController.createProvinces();
		}
		
		
		private function buildComponents():void
		{
			_mapController = new MapController();
			_mapController.initialize( _gameView.getMapView() );
		}
		
		
		
	}
}