package main.view.application.game.ui
{
	import main.broadcast.IModule;
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
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
			
			
			buildComponents();
			
		}
		
		private function buildComponents():void
		{
			_userStatsController = new UserStatsController();
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