package main
{
	import core.logic.LogicModule;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import main.boot.BootModule;
	import main.broadcast.Module;
	import main.broadcast.UniqueId;
	import main.broadcast.message.MessageData;
	import main.data.DataContainer;
	import main.data.DataParser;
	import main.events.ApplicationEvents;
	import main.view.ApplicationMainLayoutModule;
	import main.view.IViewStartupProcess;
	import main.view.StarlingBootModule;
	
	import utils.updater.Updater;

	public class ApplicationModule extends Module
	{
		public static const MODULE_NAME:		String = "ApplicationModule";
		
		private var updater:Updater;
		private var stageContainer:Stage;
		
		private var applicationLayout:IViewStartupProcess;
		
		private var logView:LogView;
		
		private var bootModule:BootModule;
		private var parseModule:DataParser;
		private var dataContainer:DataContainer;
		private var coreLogicModule:LogicModule;
		
		public function ApplicationModule()
		{
			super(this);
		}
		
		public function init(stage:Stage):void
		{
//			this.addMessageListener(ApplicationEvents.SOURCES_LOADED);
			
			stageContainer = stage;
		
			initModules();	
		}
		
		private function initModules():void
		{
			if( ApplicationDomain.currentDomain.hasDefinition("flash.display.Stage3D") ) 
			{
				applicationLayout = new StarlingBootModule();
				applicationLayout.initialize( stageContainer );
			}
			else
			{
				applicationLayout = new ApplicationMainLayoutModule();
				applicationLayout.initialize( stageContainer );
			}
			
			
			logView = new LogView();
			stageContainer.addChild(logView);	
			
			dataContainer = new DataContainer();			
			bootModule  = new BootModule();
			parseModule = new DataParser();
			coreLogicModule = new LogicModule();
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
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationEvents.CONFIG_LOADED,
				ApplicationEvents.BOOT_COMPLETE,
				ApplicationEvents.SHOW_MESSAGE
			];
		}
		
		override public function receiveMessage(message:MessageData):void
		{		
			switch(message.message)
			{
				case ApplicationEvents.CONFIG_LOADED:
				{
					logView.addMessage("CONFIG_LOADED");
					break;
				}
					
				case ApplicationEvents.BOOT_COMPLETE:
				{
					logView.addMessage("BOOT_COMPLETE");
					break;
				}
					
				case ApplicationEvents.SHOW_MESSAGE:
				{
					logView.addMessage(message.data);
					break;
				}
			}
		}
	}
}