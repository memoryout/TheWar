package main.view.starling.game.ui
{
	import flash.text.TextFieldAutoSize;
	
	import main.data.DataContainer;
	import main.data.StartupGameConfiguration;
	import main.view.application.asset.AssetManager;
	import main.view.application.asset.AtlasAsset;
	import main.view.interfaces.game.IUIGameView;
	import main.view.starling.sResourceAsset;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class UIGameView extends Sprite implements IUIGameView
	{
		private var _onUiLoadComplete:		Function;
		private var _uiImage:				Image;	
		
		private var _uiContainer:			Sprite;
		
		private var diplomacyButton			:sButtonGame;		
		private var nextStepButton			:sButtonGame;		
		private var technologyButton		:sButtonGame;
		private var settingsButton			:sButtonGame;
		
		private var buttonsContainer:Array = new Array();
		
		private var buttonsName:Array = ["bl-icons-07.eps-diplomacy.png", "next_btn.png", "settings.png", "technology.png"];
		
		private var txtCivName:TextField;
		private var txtCivMoney:TextField;
		
		public function UIGameView()
		{
			super();
		}
		
		public function initialize(onInitComplete:Function):void
		{
			_uiContainer = new Sprite();
			this.addChild( _uiContainer );
			
			if(onInitComplete != null) 
				onInitComplete();
			
			onInitComplete = null;		
		}
		
		public function loadUi(onUiLoadComplete:Function):void
		{
			_onUiLoadComplete = onUiLoadComplete;
			
			addButtons();
			addTxtFields();	
		}
		
		private function addButtons():void
		{		
			settingsButton = new sButtonGame();
			settingsButton.createView("settings.png");
			
			_uiContainer.addChild(settingsButton);
			
			buttonsContainer.push(settingsButton);
			
			settingsButton.x = sScreenUtils.getScreenRect().width - settingsButton.width;
			
			diplomacyButton = new sButtonGame();
			diplomacyButton.createView("bl-icons-07.eps-diplomacy.png");
				
			_uiContainer.addChild(diplomacyButton);			
			buttonsContainer.push(diplomacyButton);
			
			diplomacyButton.x = settingsButton.x /*- diplomacyButton.width*2*/;
			diplomacyButton.y = settingsButton.y + diplomacyButton.height;
						
			technologyButton = new sButtonGame();
			technologyButton.createView("technology.png");
			
			_uiContainer.addChild(technologyButton);
			
			buttonsContainer.push(technologyButton);	
			
			technologyButton.x = diplomacyButton.x /*- technologyButton.width*/;
			technologyButton.y = diplomacyButton.y + technologyButton.height;
			
			nextStepButton = new sButtonGame();
			nextStepButton.createView("next_btn.png");
			
			_uiContainer.addChild(nextStepButton);
			
			buttonsContainer.push(nextStepButton);
			
			nextStepButton.x = sScreenUtils.getScreenRect().width - nextStepButton.width;
			nextStepButton.y = sScreenUtils.getScreenRect().height - nextStepButton.height;						
		}
		
		private function addTxtFields():void
		{
			txtCivName = new TextField(300, 76.7, "txtCivName");
			
			txtCivName.color	 = 0x000000;
			txtCivName.fontSize	 = 60;
			txtCivName.fontName	 = "CenturyGothic";
			txtCivName.autoSize  = TextFieldAutoSize.LEFT;			
			txtCivName.touchable = false;		
			txtCivName.border = true;
			
			txtCivName.scaleX 			= txtCivName.scaleY 		= sScreenUtils.getResourceScaleFactor();
						
			this.addChild(txtCivName);
			
			txtCivMoney = new TextField(300, 76.7, "hhh");
			
			txtCivMoney.color	  = 0x000000;
			txtCivMoney.fontSize  = 60;
			txtCivMoney.fontName  = "CenturyGothic";
			txtCivMoney.autoSize  = TextFieldAutoSize.LEFT;	
			txtCivMoney.touchable = false;
			txtCivMoney.border = true;
			
			txtCivMoney.scaleX 			= txtCivMoney.scaleY 		= sScreenUtils.getResourceScaleFactor();
			
			this.addChild(txtCivMoney);
			
			txtCivMoney.x = txtCivName.x + txtCivName.width;
		}
		
		public function getCivilizationNameTxt():TextField
		{
			return txtCivName;
		}
		
		public function getCivilizationMoneyTxt():TextField
		{
			return txtCivMoney;
		}
	}
}