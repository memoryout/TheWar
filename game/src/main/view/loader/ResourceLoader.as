package main.view.loader
{
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	
	import main.view.application.asset.AssetManager;
	import main.view.application.asset.AtlasLoader;

	public class ResourceLoader
	{
		private var _onLoadComplete:	Function;
		private var _onLoadError:		Function;
		
		private var _errorLoad:			Vector.<String>;
		
		private var _filesToLoad:		Vector.<LoadFileData>;
		
		public function ResourceLoader()
		{
			_filesToLoad = new Vector.<LoadFileData>();
			_errorLoad = new Vector.<String>();
		}
		
		public function addToLoadList(url:String, libraryName:String, type:uint):void
		{
			var fileData:LoadFileData = new LoadFileData();
			fileData.name = libraryName;
			fileData.type = type;
			fileData.url = url;
			
			_filesToLoad.push(fileData);
		}
		
		public function startLoad( onLoadComplete:Function, onErrorLoad:Function):void
		{
			_onLoadComplete = onLoadComplete;
			_onLoadError = onErrorLoad;
			
			loadNextFile();
		}
		
		
		private function loadNextFile():void
		{
			if(_filesToLoad.length > 0)
			{
				var fileData:LoadFileData = _filesToLoad.shift();
				
				switch(fileData.type)
				{
					case ResourceType.SWF:
					{
						var loaderInfo:LoaderInfo = AssetManager.loadAsset(fileData.url, fileData.name);
						loaderInfo.addEventListener(Event.INIT, handlerAssetLoadComplete);
						loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerAssetLoadError);
						break;
					}
						
					case ResourceType.ATLAS:
					{
						var atlasLoader:AtlasLoader = AssetManager.loadAtlas(fileData.url, fileData.name);
						atlasLoader.addEventListener(Event.COMPLETE, handlerAtlasLoaded);
						atlasLoader.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadAtlas);
						break;
					}
						
					case ResourceType.TEXT:
					{
						var textLoader:URLLoader = AssetManager.loadText(fileData.url, fileData.name);
						textLoader.addEventListener(Event.COMPLETE, handlerTextLoaded);
						textLoader.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadText);
						break;
					}
				}
			}
			else
			{
				if(_errorLoad.length == 0)
				{
					_onLoadError = null;
					if(_onLoadComplete != null) _onLoadComplete();
					_onLoadComplete = null;
				}
				else
				{
					_onLoadComplete = null;
					if(_onLoadError != null) _onLoadError();
					_onLoadError = null;
				}
			}
		}
		
		public function load(url:String, folder:String, onLoadComplete:Function, onErrorLoad:Function):void
		{
			var loaderInfo:LoaderInfo = AssetManager.loadAsset(url, folder);
			loaderInfo.addEventListener(Event.INIT, handlerAssetLoadComplete);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerAssetLoadError);
		}
		
		public function destroy():void
		{
			_onLoadComplete = null;
			_onLoadError = null;
			
			_errorLoad.length = 0;
			_filesToLoad.length = 0;
		}
		
		private function handlerAssetLoadComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerAssetLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerAssetLoadError);
			
			loadNextFile();
		}
		
		private function handlerAssetLoadError(e:IOErrorEvent):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerAssetLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerAssetLoadError);
			
			_errorLoad.push( e.toString() );
			
			loadNextFile();
		}
		
		private function handlerAtlasLoaded(e:Event):void
		{
			var atlasLoader:AtlasLoader = e.currentTarget as AtlasLoader;
			atlasLoader.removeEventListener(Event.COMPLETE, handlerAtlasLoaded);
			atlasLoader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadAtlas);
			
			loadNextFile();
		}
		
		private function handlerErrorLoadAtlas(e:IOErrorEvent):void
		{
			var atlasLoader:AtlasLoader = e.currentTarget as AtlasLoader;
			atlasLoader.removeEventListener(Event.COMPLETE, handlerAtlasLoaded);
			atlasLoader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadAtlas);
			
			_errorLoad.push( e.toString() );
			
			loadNextFile();
		}
		
		private function handlerTextLoaded(e:Event):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, handlerTextLoaded);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadText);
			
			loadNextFile();
		}
		
		private function handlerErrorLoadText(e:IOErrorEvent):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, handlerTextLoaded);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadText);
			
			_errorLoad.push( e.toString() );
			
			loadNextFile();
		}
	}
}

class LoadFileData {
	
	public var url:String;
	public var type:uint;
	public var name:String;
	
}