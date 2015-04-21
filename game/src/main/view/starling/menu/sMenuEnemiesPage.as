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
	
	public class sMenuEnemiesPage implements IViewMenuStartPage
	{
		private var _layout					:Sprite;
		private var _initCompleteCallback	:Function;
		
		private var buttonContainer	:Array = new Array();
		
		private var _btnBack:			sButtonMenu;
		
		public function sMenuEnemiesPage()
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
				button.setAction(civ[i].name + "_scenario_action_" + civ[i].id);
				
				if(checkIfCivWasUnselected(civ[i].name))
					button.setEnableCheckBox();
				else
					button.setDisableCheckBox();
					
				buttonContainer.push(button);
				
				_layout.addChild( button );
				
				button.y = /*4*button.height + */1.1*i*button.height;
			}
			
			_btnBack = new sButtonMenu("");
			_btnBack.createView("Back");
			_btnBack.setAction("back_game");
			
			buttonContainer.push(_btnBack);
			
			_layout.addChild( _btnBack );
			
			_btnBack.y = 1.1*civ.length*_btnBack.height;		
		}	
		
		private function checkIfCivWasUnselected(name:String):Boolean
		{
			for (var i:int = 0; i < StartupGameConfiguration.Get().enemiesList.length; i++) 
			{
				if(StartupGameConfiguration.Get().enemiesList[i].name == name)
					return true;
			}
			
			return false;
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
			}
			
			_layout = null;
		}
		
		private function handlerTouch(e:TouchEvent):void
		{
			for (var i:int = 0; i < buttonContainer.length; i++) 
			{
				if(buttonContainer[i])
				{
					var touch:Touch = e.getTouch(buttonContainer[i]);
					var splited:Array = (buttonContainer[i].getAction() as String).split("_");
					
					if(touch && touch.phase == TouchPhase.ENDED) 
					{
						StartupGameConfiguration.Get().scenario = int(splited[3]);
						
						if(buttonContainer[i].getAction() == "back_game")
						{
							UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.BACK_ENEMIES_BUTTON_CLICKED);
							
						}else
						{							
							UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.ENEMIES_ITEM_BUTTON_CLICKED);
							
							if(buttonContainer[i] && buttonContainer[i].selectedCheckBox)
							{
								buttonContainer[i].setDisableCheckBox();
								StartupGameConfiguration.Get().enemies--;
								
								removeCivilization(splited[0]);
							}
	
							else if(buttonContainer[i] && !buttonContainer[i].selectedCheckBox)
							{
								buttonContainer[i].setEnableCheckBox();
								StartupGameConfiguration.Get().enemies++;
								
								addCivilization(splited[0]);
							}
						}						
					}
				}				
			}
		}	
		
		private function addCivilization(name:String):void
		{
			for (var i:int = 0; i < DataContainer.Get().getCivilizationList().length; i++) 
			{
				if(DataContainer.Get().getCivilizationList()[i].name == name)
					StartupGameConfiguration.Get().enemiesList.splice(i, 0, DataContainer.Get().getCivilizationList()[i]);
			}
		}
		
		private function removeCivilization(name:String):void
		{
			for (var i:int = 0; i < StartupGameConfiguration.Get().enemiesList.length; i++) 
			{
				if(StartupGameConfiguration.Get().enemiesList[i].name == name)
					StartupGameConfiguration.Get().enemiesList.splice(i,1);
			}
		}
		
	}
}