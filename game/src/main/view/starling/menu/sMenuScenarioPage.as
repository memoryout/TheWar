package main.view.starling.menu
{
	import com.greensock.TweenLite;
	
	import core.logic.LogicData;
	
	import flash.events.MouseEvent;
	
	import main.data.DataContainer;
	import main.data.ScenarioInfo;
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
	
	public class sMenuScenarioPage implements IViewMenuStartPage
	{
		private var _layout					:Sprite;
		private var _initCompleteCallback	:Function;
		
		private var buttonContainer	:Array = new Array();
		
		public function sMenuScenarioPage()
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
			var scenarios:Vector.<ScenarioInfo> = DataContainer.Get().getScenariousList();
			
			for (var i:int = 0; i < scenarios.length; i++) 
			{
				var button:sButtonMenu = new sButtonMenu("");
				button.createView(scenarios[i].name);
				button.setAction(scenarios[i].name + "_scenario_action_" + scenarios[i].id);
				
				buttonContainer.push(button);
				
				_layout.addChild( button );
				
				button.y = /*4*button.height + */1.1*i*button.height;
			}
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
						
						UserInputSystem.get().processAction(MouseEvent.CLICK, MenuActionList.SCENARIO_ITEM_BUTTON_CLICKED);
					}
				}				
			}
		}		
	}
}