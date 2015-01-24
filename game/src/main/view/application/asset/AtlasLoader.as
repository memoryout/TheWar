package main.view.application.asset
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class AtlasLoader extends EventDispatcher
	{
		private var _loader:		URLLoader;
		
		private var _rootURL:		String;
		private var _xmlURL:		String;
		
		private var _xmlData:		String;
		private var _bitmapData:	BitmapData;
		
		private var _xmlLoader:		URLLoader;
		private var _atlasName:		String;
		
		public function AtlasLoader(name:String)
		{
			super();
			
			_atlasName = name;
		}
		
		public function loadAtlas(xmlURL:String):void
		{
			_rootURL = xmlURL;
			_xmlURL = xmlURL;
			
			var urlPath:Array = _rootURL.split("/");
			urlPath.pop();
			_rootURL = urlPath.join("/");
			
			loadXML();
		}
		
		public function getXML():String 
		{
			return _xmlData;
		}
		
		public function getImage():BitmapData
		{
			return _bitmapData;
		}
		
		public function getAtlasName():String
		{
			return _atlasName;
		}
		
		private function loadXML():void
		{
			_xmlLoader = new URLLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, handlerLoadXML);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadXML);
			_xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_xmlLoader.load(new URLRequest(_xmlURL));
		}
		
		private function handlerLoadXML(e:Event):void
		{
			_xmlLoader.removeEventListener(Event.COMPLETE, handlerLoadXML);
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadXML);
			
			_xmlData = _xmlLoader.data as String;
			
			loadImageFromXML();
		}
		
		private function handlerErrorLoadXML(e:IOErrorEvent):void
		{
			_xmlLoader.removeEventListener(Event.COMPLETE, handlerLoadXML);
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadXML);
			
			this.dispatchEvent( new IOErrorEvent("Can't load atlas xml from: " + _xmlURL) );
		}
		
		
		private function loadImageFromXML():void
		{
			var xml:XML;
			
			try
			{
				xml = new XML(_xmlData);
			}
			catch(e:Error)
			{
				loadImageFromXMLPath();
				return;
			}

			var fileName:String = xml.@imagePath;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handlerLoadImage);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadImage);
			loader.load( new URLRequest(_rootURL + "/" + fileName) );
		}
		
		private function handlerLoadImage(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, handlerLoadImage);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadImage);
			
			_bitmapData = (loaderInfo.content as Bitmap).bitmapData;
			
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		private function handlerErrorLoadImage(e:IOErrorEvent):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, handlerLoadImage);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadImage);
		}
		
		private function loadImageFromXMLPath():void
		{
			
		}
		
		
		public function destroy():void
		{
			_loader = null;
			_bitmapData = null;
			_xmlLoader = null;
		}
	}
}