package main.boot
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import main.boot.task.SimpleTask;
	import main.boot.task.TaskEvent;
	import main.events.ErrorEvents;

	public class ConfigLoader extends SimpleTask
	{
		private var _urls:							String;
		private var _files:							Vector.<String>;
		
		private var _loader:						URLLoader;
		
		public function ConfigLoader()
		{
			super();
		}
		
		override public function run(...args):void
		{
			_urls = args[0];
			
			_files = new Vector.<String>;
			
			loadNextFile();
		}
		
		
		public function get filesData():Vector.<String>
		{
			return _files;
		}
		
		
		private function loadNextFile():void
		{
			if(_urls.length)
			{
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, handlerLoadData);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadData);
				_loader.load( new URLRequest(_urls) );
			}
			else
			{
				this.dispachLocalEvent( TaskEvent.COMPLETE, this );
			}
		}
		
		
		private function handlerErrorLoadData(e:IOErrorEvent):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, handlerLoadData);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadData);
			
			_loader = null;
			
			this.dispachLocalEvent( TaskEvent.ERROR, ErrorEvents.ERROR_LOAD_GAME_DATA);
			this.destroy();
		}
		
		
		private function handlerLoadData(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, handlerLoadData);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadData);
			
			_files.push( e.currentTarget.data as String);
			
			_loader = null;
			
			loadNextFile();
		}
		
		
		override public function destroy():void
		{
			_urls = null;
			_files = null;
			
			if(_loader)
			{
				_loader.removeEventListener(Event.COMPLETE, handlerLoadData);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadData);
			}
			
			_loader = null;
			
			super.destroy();
		}
	}
}