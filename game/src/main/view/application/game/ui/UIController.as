package main.view.application.game.ui
{
	import main.broadcast.IModule;
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.data.DataContainer;
	import main.data.StartupGameConfiguration;
	import main.view.application.ApplicationEvent;
	import main.view.interfaces.game.IUIGameView;
	
	public class UIController extends Module
	{
		private var _userStatsController:		UserStatsController;
		
		private var _uiGameView:				IUIGameView;
		
		public function UIController()
		{
			super(this);
		}
		
		
		public function initialize(uiView:IUIGameView):void
		{
			_uiGameView = uiView;
			
			_uiGameView.initialize(onUiInitComplete);
			
			buildComponents();
			
			setData();			
		}
		
		private function onUiInitComplete():void
		{
			_uiGameView.loadUi(onUiLoaded);
		}
		
		private function onUiLoaded():void
		{
			
		}
		
		private function buildComponents():void
		{
			_userStatsController = new UserStatsController();
		}
		
		private function setData():void
		{
			for (var i:int = 0; i < DataContainer.Get().getCivilizationList().length; i++) 
			{
				if(DataContainer.Get().getCivilizationList()[i].id == StartupGameConfiguration.Get().civilization)
				{
					_uiGameView.getCivilizationNameTxt().text = DataContainer.Get().getCivilizationList()[i].name;
					_uiGameView.getCivilizationMoneyTxt().text = "$" + DataContainer.Get().getCivilizationList()[i].money.toString();
				}
			}
		}
		
		override public function receiveMessage(message:MessageData):void
		{
			switch( message.message )
			{
				case ApplicationEvent.PROVINCE_SELECT:
				{
					
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array 
		{
			
			return [
				ApplicationEvent.PROVINCE_SELECT
			];
			
		}
	}
}