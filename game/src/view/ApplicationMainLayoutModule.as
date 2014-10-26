package view
{
	import flash.display.Stage;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.events.ApplicationEvents;
	import view.application.ApplicationRootContext;
	
	public class ApplicationMainLayoutModule extends Module
	{
		public static const MODULE_NAME:		String = "app.view.main-layout";
		
		private var _mainLayout:				ApplicationMainLayout;
		private var _rootContext:				ApplicationRootContext;
		
		public function ApplicationMainLayoutModule()
		{
			super();
			
			setSharedModule( MODULE_NAME, this );
		}
		
		public function initialize(stage:Stage):void
		{
			_mainLayout = new ApplicationMainLayout();
			stage.addChild( _mainLayout );
			
			
		}
		
		
		override public function receiveMessage(message:MessageData):void
		{
			switch(message.message)
			{
				case ApplicationEvents.SOURCES_LOADED:
				{
					_mainLayout.initialize();
					
					createRootContext();
					
					break;
				}
			}
		}
		
		private function createRootContext():void
		{
			_rootContext = new ApplicationRootContext();
			_rootContext.init( _mainLayout.canvas );
		}
	}
}