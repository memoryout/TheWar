package main.boot
{
	import main.MainGlobalVariables;
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
			setSharedModule( MODULE_NAME, this );
			
			loadGameSource();
			loadData();
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
			dataLoader.addListener(TaskEvent.COMPLETE, handlerErrorLoadData);
			dataLoader.addListener(TaskEvent.ERROR, handlerLoadData);
			dataLoader.run( MainGlobalVariables.SQL_FILE_URL/*, _mainGameController*/ );
		}
		
		private function handlerErrorLoadData(error:String):void
		{
			sendMessage( ErrorEvents.ERROR_LOAD_GAME_DATA );
		}
				
		private function handlerLoadData(task:ConfigLoader):void
		{
			sendMessage(ApplicationEvents.CONFIG_LOADED, null);
			
			var files:Vector.<String> = task.filesData;
			
			task.destroy();
			
			var i:int;
			for(i = 0; i < files.length; i++)
			{
//				this.sendMessage(StaticDataManagerCommands.PARSE_STATIC_DATA, files[i]);
			}
		}
	}
}