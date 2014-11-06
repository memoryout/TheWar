package main.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	
	public class GameHUD extends AppSprite
	{
		public static const CLICK_ON_NEXT_STEP:			String = "click_next_step";
		
		private var _skin:			MovieClip;
		
		private var _btNext:		MovieClip;
		private var _btFinish:		MovieClip;
		
		private var _bottomBg:		MovieClip;
		private var _txtInfo:		TextField;
		
		public function GameHUD()
		{
			super();
		}
		
		public function initialize():void
		{
			var classRef:Class = AssetManager.getClass("ui","game.ui.hud");
			if(classRef)
			{
				_skin = new classRef();
				this.addChild( _skin );
				
				_btNext = _skin.getChildByName("btNext") as MovieClip;
				_btFinish = _skin.getChildByName("btFinish") as MovieClip;
				_bottomBg = _skin.getChildByName("bottom_bg") as MovieClip;
				_txtInfo = _skin.getChildByName("txtInfo") as TextField;
				
				_btNext.addEventListener(MouseEvent.CLICK, handlerClickNext);
				_btFinish.addEventListener(MouseEvent.CLICK, handlerClickNext);
				
				handlerChanges();
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
		
		
		public function writeMessage(message:String):void
		{
			_txtInfo.text = message;
		}
		
		
		private function handlerClickNext(e:MouseEvent):void
		{
			this.dispatchEvent( new Event(CLICK_ON_NEXT_STEP) );
		}
		
		
		override public function handlerChanges():void
		{
			var screenWidth:Number = AppSprite.getScreenSize().width;
			var scrrenHeight:Number = AppSprite.getScreenSize().height;
			
			if(_bottomBg)
			{
				_bottomBg.scaleX = _bottomBg.scaleY = AppSprite.getScaleFactor();
				_bottomBg.x = 0;
				_bottomBg.y = scrrenHeight - _bottomBg.height;
			}
			
			if(_btNext)
			{
				_btNext.scaleX = _btNext.scaleY = AppSprite.getScaleFactor();
				_btNext.x = screenWidth - _btNext.width - 5;
				_btNext.y = _bottomBg.y + 1;
			}
			
			if(_btFinish)
			{
				_btFinish.scaleX = _btFinish.scaleY = AppSprite.getScaleFactor();
				_btFinish.x = screenWidth - _btFinish.width - 5;
				_btFinish.y = _bottomBg.y + 1;
			}
			
			if(_txtInfo)
			{
				_txtInfo.scaleX = _txtInfo.scaleY = AppSprite.getScaleFactor();
				_txtInfo.x = 5;
				_txtInfo.y = _bottomBg.y + 1;
			}
		}
	}
}