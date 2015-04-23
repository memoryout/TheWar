package main.view.starling.menu
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import main.data.CivilizationInfo;
	import main.data.DataContainer;
	import main.data.StartupGameConfiguration;
	import main.view.application.menu.MenuActionList;
	import main.view.input.UserInputSystem;
	import main.view.interfaces.menu.IViewMenuStartPage;
	import main.view.starling.menu.simple.sButtonMenu;
	import main.view.starling.sScreenUtils;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class sMenuCivilizationsPage implements IViewMenuStartPage
	{
		private var _layout					:Sprite;
		private var _initCompleteCallback	:Function;
		
		private var buttonContainer	:Array = new Array();
		
		private var _btnBack:			sButtonMenu;
		
		public function sMenuCivilizationsPage()
		{
		}
		
		public function initialize(onInitComplete:Function):void
		{
			_initCompleteCallback = onInitComplete;
			
			if(_initCompleteCallback != null) 
				_initCompleteCallback();
			
			_initCompleteCallback = null;
		}
		
		public function setLayout(layout:Sprite):void
		{
			_layout = layout;
		}
		
		public function showPage():void
		{		
			addButtons();
			showButtons();
			
			_layout.addEventListener(TouchEvent.TOUCH, handlerTouch);
		}
		
		private function addButtons():void
		{			
			var civ:Vector.<CivilizationInfo> = DataContainer.Get().getCivilizationList();
			
			for (var i:int = 0; i < civ.length; i++) 
			{
				var button:sButtonMenu = new sButtonMenu("");
				button.createView(civ[i].name);
				button.setAction(civ[i].name + "_civ_action_" + civ[i].id);
				
				buttonContainer.push(button);
				
				_layout.addChild( button );
				
				button.y = /*4*button.height + */1.1*i*button.height;
			}
			
			_btnBack = new sButtonMenu("menu.back0000");
			_btnBack.createView("Back");
			_btnBack.setAction("back_game");
						
			_layout.addChild( _btnBack );
			
			_btnBack.alpha = 0;
			
			_btnBack.x = sScreenUtils.getScreenRect().width - _btnBack.width;
		}	
		
		private function showButtons():void
		{			
			var _delay:Number = 0;
			
			for (var i:int = 0; i < buttonContainer.length; i++) 
			{
				buttonContainer[i].alpha = 0;
				
				TweenLite.to(buttonContainer[i], 0.5, {alpha:1, x:sScreenUtils.getScreenRect().width - buttonContainer[i].width >> 1, delay:_delay});
				
				_delay += 0.1;
			}
			
			TweenLite.to(_btnBack, 0.7, {alpha:1});
		}
		public function hidePage():void
		{
			if(_layout) 
			{
				_layout.removeEventListener(TouchEvent.TOUCH, handlerTouch);
				
				for (var i:int = 0; i < buttonContainer.length; i++) 
				{
					if(buttonContainer[i] && _layout.contains( buttonContainer[i]))
					{
						_layout.removeChild( buttonContainer[i] );					
						
						buttonContainer[i].destroy();
						buttonContainer[i] = null;
					}
				}
				
				if(_btnBack && _layout.contains( _btnBack))
				{
					_layout.removeChild( _btnBack );					
					
					_btnBack.destroy();
					_btnBack = null;
				}
			}
			
			_layout = null;
		}
		
		private function handlerTouch(e:TouchEvent):void
		{
			var touch:Touch;
			
			for (var i:int = 0; i < buttonContainer.length; i++) 
			{
				if(buttonContainer[i])
				{
					touch = e.getTouch(buttonContainer[i]);
					var splited:Array = (buttonContainer[i].getAction() as String).split("_");
					
					if(touch && touch.phase == TouchPhase.ENDED) 
					{
						StartupGameConfiguration.Get().civilization = int(splited[3]);
						StartupGameConfiguration.Get().civilizationName = splited[0];
						
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.CIVILIZATION_ITEM_BUTTON_CLICKED);
					}
				}				
			}
			
			
			touch = e.getTouch(_btnBack);
			
			if(touch && touch.phase == TouchPhase.ENDED) 
			{
				UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.BACK_CIV_BUTTON_CLICKED);
			}
		}
	}
}