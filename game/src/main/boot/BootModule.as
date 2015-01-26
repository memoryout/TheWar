package main.boot
{	
	import main.MainGlobalVariables;
	import main.boot.interfaces.ISQLManager;
	import main.boot.sqllite.SQLManager;
	import main.boot.task.SimpleTask;
	import main.boot.task.TaskEvent;
	import main.broadcast.Module;
	import main.events.ApplicationEvents;
	import main.events.ErrorEvents;

	public class BootModule extends Module
	{
		public static const MODULE_NAME:		String = "BootModule";
		
		public function BootModule()
		{
			super(this);
			
			//loadGameSource();
			loadData();
			loadSqLite();
		}
		
		//load swf
		private function loadGameSource():void
		{
			var loader:SourceLoader = new SourceLoader();
			loader.addListener(TaskEvent.COMPLETE, handlerSourceLoadComplete);
			loader.addListener(TaskEvent.ERROR, handlerErrorLoadSources);
			loader.run( MainGlobalVariables.SOURCE_URL );
		}
				
		private function handlerErrorLoadSources(task:SimpleTask):void
		{
			task.destroy();
			sendMessage(ErrorEvents.ERROR_LOAD_GAME_SOURCE_FILE, null);
		}
		
		private function handlerSourceLoadComplete(task:SimpleTask):void
		{		
			sendMessage(ApplicationEvents.SOURCES_LOADED, null);
			task.destroy();	
		}
				
		//load config
		private function loadData():void
		{
			var dataLoader:ConfigLoader = new ConfigLoader();
			dataLoader.addListener(TaskEvent.COMPLETE, handlerLoadData);
			dataLoader.addListener(TaskEvent.ERROR, handlerErrorLoadData);
			dataLoader.run( MainGlobalVariables.CONFIG_URL );
		}
		
		private function handlerErrorLoadData(error:String):void
		{
			sendMessage( ErrorEvents.ERROR_LOAD_GAME_DATA );
		}
				
		private function handlerLoadData(task:ConfigLoader):void
		{		
			var files:Vector.<String> = task.filesData;
			
			task.destroy();
			
			var i:int;
			for(i = 0; i < files.length; i++)
			{
				this.sendMessage(ApplicationEvents.PARSE_CONFIG, files[i]);
			}	
			
			sendMessage(ApplicationEvents.CONFIG_LOADED, files);
			
			sendMessage( ApplicationEvents.BOOT_COMPLETE );
		}
		
		private function loadSqLite():void
		{
			SQLManager.init();
			
			ServicesList.addSearvice( new SQLManager() );
			
			var sql:ISQLManager = ServicesList.getSearvice( ServicesList.SQL_MANAGER ) as ISQLManager;
			sql.connect(MainGlobalVariables.SQL_FILE_URL, onConnect, onErrorConnect);
		}
		
		
		private function onConnect():void
		{
//			this.sendNotification( ApplicationEvents.USER_DATA_PROXY_CONNECTED);
			trace("onErrorConnect to data base");
		}
		
		private function onErrorConnect():void
		{
			trace("onErrorConnect to data base");
		}
	}
}