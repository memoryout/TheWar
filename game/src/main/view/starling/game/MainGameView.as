package main.view.starling.game
{
	import main.view.interfaces.IViewObject;
	import main.view.interfaces.game.IMainGameView;
	import main.view.interfaces.game.IMapView;
	import main.view.interfaces.game.IUIGameView;
	import main.view.starling.game.map.MapView;
	import main.view.starling.game.ui.UIGameView;
	
	import starling.display.Sprite;
	
	public class MainGameView extends Sprite implements IMainGameView
	{
		private var _mapView:			MapView;
		private var _uiView:			UIGameView;
		
		public function MainGameView()
		{
			super();
		}
		
		public function initialize(onInitComplete:Function):void
		{
			_mapView = new MapView();
			this.addChild( _mapView );
			
			_uiView = new UIGameView();
			this.addChild( _uiView );
			
			if(onInitComplete != null) 
				onInitComplete();
			
			onInitComplete = null;
		}
		
		public function getMapView():IMapView
		{
			return _mapView;
		}
		
		public function getUIView():IUIGameView
		{
			return _uiView;
		}
	}
}