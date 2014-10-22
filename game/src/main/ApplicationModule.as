package main
{
	import main.data.DataContainer;
	import core.logic.LogicModule;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	import main.boot.BootModule;
	import main.broadcast.Module;
	import main.broadcast.UniqueId;
	import main.broadcast.message.MessageData;
	import main.data.DataParser;
	import main.events.ApplicationEvents;
	
	import utils.updater.Updater;

	public class ApplicationModule extends Module
	{
		public static const MODULE_NAME:		String = "ApplicationModule";
		
		private var updater:Updater;
		private var stageContainer:Stage;
		
		private var bootModule:BootModule;
		private var parseModule:DataParser;
		private var dataContainer:DataContainer;
		private var coreLogicModule:LogicModule;
		
		private var logView:LogView;
		
		public function ApplicationModule()
		{
			setSharedModule( MODULE_NAME, this );
		}
		
		public function init(stage:Stage):void
		{
//			this.addMessageListener(ApplicationEvents.SOURCES_LOADED);
			
			stageContainer = stage;
		
			initModules();	
			
			dataContainer = new DataContainer();
			
			bootModule  = new BootModule();
			parseModule = new DataParser();
			coreLogicModule = new LogicModule();
		}
		
		private function initModules():void
		{
			logView = new LogView();
			stageContainer.addChild(logView);			
		}
		
		private function initUpdater(stage:Stage):void
		{
			updater = new Updater();
			updater.init();
			
			stage.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}
		
		private function handlerEnterFrame(e:Event):void
		{
			Updater.get().update();
		}
		
		override public function receiveMessage(message:MessageData):void
		{		
			switch(message.message)
			{
				case ApplicationEvents.SOURCES_LOADED:
				{
//					logView.addMessage("SOURCES_LOADED");
					break;
				}	
					
				case ApplicationEvents.CONFIG_LOADED:
				{
//					logView.addMessage("CONFIG_LOADED");
					break;
				}
				
				case ApplicationEvents.DATA_SAVED:
				{
					logView.addMessage("DATA_SAVED");
					break;
				}					
			}
		}
	}
}