package main.view.application.game
{
	import core.logic.data.StateOfCivilization;
	import core.logic.data.StateOfProvince;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import main.data.MapInfo;
	import main.data.ProvinceInfo;
	import main.view.AppSprite;
	import main.view.application.asset.AssetManager;
	import main.view.application.data.GameDataProvider;
	import main.view.input.UserInputSystem;
	
	public class GameHUD extends AppSprite
	{
		public static const CLICK_ON_NEXT_STEP:			String = "click_next_step";
		
		private var _skin:			MovieClip;
		
		private var _btNext:		MovieClip;
		private var _btFinish:		MovieClip;
		
		private var _bottomBg:		MovieClip;
		private var _txtInfo:		TextField;
		
		private var _infoSkin:		MovieClip;
		
		private var _btCreateAction:SimpleButton;
		
		private var _provinces:			Vector.<StateOfProvince>;
		private var _civilizationList:	Vector.<StateOfCivilization>;
		
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
				
				_btCreateAction = _skin.getChildByName("btCreateAction") as SimpleButton;
				
				_infoSkin = _skin.getChildByName("infoSkin") as MovieClip;
				_infoSkin.gotoAndStop(1);
				
				_btNext.addEventListener(MouseEvent.CLICK, handlerClickNext);
				_btFinish.addEventListener(MouseEvent.CLICK, handlerClickNext);
				_btCreateAction.addEventListener(MouseEvent.CLICK, handlerClickMakeAction);
				
				
				
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
		
		public function showContextInfo(userAction:String):void
		{
			var action:Array = userAction.split(".");
			
			if(action.length == 2)
			{
				if(action[0] == "region")
				{
					showProvinceInfo( int(action[1]) );
				}
				else setNoInfoState();
			}
		}		
		
		private function handlerClickNext(e:MouseEvent):void
		{
			this.dispatchEvent( new Event(CLICK_ON_NEXT_STEP) );
		}
		
		private function handlerClickMakeAction(e:MouseEvent):void
		{
			UserInputSystem.get().processAction(MouseEvent.CLICK, "button.make_action");
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
				
				_txtInfo.visible = false;
			}
			
			if(_infoSkin)
			{
				_infoSkin.scaleX = _infoSkin.scaleY = AppSprite.getScaleFactor();
				_infoSkin.y = _bottomBg.y + 1;
				_infoSkin.x = 5;
			}
			
			if(_btCreateAction)
			{
				_btCreateAction.scaleX = _btCreateAction.scaleY = AppSprite.getScaleFactor();
				_btCreateAction.y = AppSprite.getViewportSize().height/2;
				_btCreateAction.x = 10;
			}
		}
		
		
		private function setNoInfoState():void
		{
			_infoSkin.gotoAndStop("NoInfo");
		}
		
		
		private function showProvinceInfo( provinceId:int ):void
		{
			var civilization:StateOfCivilization = GameDataProvider.Get().getCivilizationByProvinceId( provinceId );
			var txt:TextField;
			
			if(civilization)
			{
				_infoSkin.gotoAndStop("ProvinceExtendedInfo");
				
				txt = _infoSkin.getChildByName("TxtCivId") as TextField;
				if(txt) txt.text = civilization.id.toString();
				
				txt = _infoSkin.getChildByName("TxtCivName") as TextField;
				if(txt) txt.text = civilization.name;
				
				txt = _infoSkin.getChildByName("TxtCivFlag") as TextField;
				if(txt) txt.text = civilization.flag;
				
				txt = _infoSkin.getChildByName("TxtCivMoney") as TextField;
				if(txt) txt.text = civilization.money.toString();
				
				txt = _infoSkin.getChildByName("TxtCivCraft") as TextField;
				if(txt) txt.text = civilization.totalBonusFromCrafting.toString();
				
				txt = _infoSkin.getChildByName("TxtCivTrade") as TextField;
				if(txt) txt.text = civilization.totalBonusFromDiplomacyTrade.toString();
				
				txt = _infoSkin.getChildByName("TxtCivArmy") as TextField;
				if(txt) txt.text = civilization.army.attack + "/" + civilization.army.defence + "/" + civilization.army.speed;
				
				var provinceState:StateOfProvince = GameDataProvider.Get().getStateOfProvince( civilization.id, provinceId );
				
				txt = _infoSkin.getChildByName("TxtProvinceId") as TextField;
				if(txt) txt.text = provinceState.id.toString();
				
				txt = _infoSkin.getChildByName("TxtProvinceMoney") as TextField;
				if(txt) txt.text = provinceState.moneyGrowth.toString();
				
				txt = _infoSkin.getChildByName("TxtProvinceBuildings") as TextField;
				if(txt) txt.text = provinceState.buildingList.length.toString();
				
				txt = _infoSkin.getChildByName("TxtProvinceArmy") as TextField;
				if(txt) txt.text = provinceState.armyNumber.toString();
				
				txt = _infoSkin.getChildByName("TxtIsUser") as TextField;
				if(txt)
				{
					if( GameDataProvider.Get().isUserCivilization( civilization.id) ) txt.text = "true";
					else txt.text = "false";
				}				
			}
			else
			{
				_infoSkin.gotoAndStop("ProvinceShortInfo");
				
				var province:ProvinceInfo = GameDataProvider.Get().getProvinceInfo( provinceId );
				
				txt = _infoSkin.getChildByName("TxtProvinceId") as TextField;
				if(txt) txt.text = province.id.toString();
				
				txt = _infoSkin.getChildByName("TxtMoney") as TextField;
				if(txt) txt.text = province.moneyGrowth.toString();
				
				txt = _infoSkin.getChildByName("TxtNeighbors") as TextField;
				if(txt) txt.text = province.neighboringRegions.toString();
			}
		}
	}
}