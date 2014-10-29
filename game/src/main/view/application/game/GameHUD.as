package main.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import main.view.R;
	
	public class GameHUD extends Sprite
	{
		public static const CLICK_ON_NEXT_STEP:			String = "click_next_step";
		
		private var _skin:			MovieClip;
		
		private var _btNext:		MovieClip;
		private var _btFinish:		MovieClip;
		
		public function GameHUD()
		{
			super();
		}
		
		public function initialize():void
		{
			var classRef:Class = R.getClass("game.ui.hud");
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				_btNext = _skin.getChildByName("btNext") as MovieClip;
				_btFinish = _skin.getChildByName("btFinish") as MovieClip;
				
				_btNext.addEventListener(MouseEvent.CLICK, handlerClickNext);
				_btFinish.addEventListener(MouseEvent.CLICK, handlerClickNext);
			}
		}
		
		
		public function setUserActivitySkin():void
		{
			_btNext.visible = false;
			_btFinish.visible = true;
		}
		
		public function setGameInfoSkin():void
		{
			_btNext.visible = true;
			_btFinish.visible =false;
		}
		
		
		private function handlerClickNext(e:MouseEvent):void
		{
			this.dispatchEvent( new Event(CLICK_ON_NEXT_STEP) );
		}
	}
}