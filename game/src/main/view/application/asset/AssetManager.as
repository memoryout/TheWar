package main.view.application.asset
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	public class AssetManager
	{
		private static const _domains:			Dictionary = new Dictionary();
		
		private static const _atlassList:		Dictionary = new Dictionary();
		private static const _textList:			Dictionary = new Dictionary();
		
		public function AssetManager()
		{
			
		}
		
		public static function loadAsset(url:String, path:String):LoaderInfo
		{
			var loader:Loader = new Loader();
			var req:URLRequest = new URLRequest(url);
			
			
			var domain:ApplicationDomain = new ApplicationDomain();
			_domains[path] = domain;
			
			
			loader.load(req, new LoaderContext(false, domain) );
			
			return loader.contentLoaderInfo;
		}
		
		public static function getClass(source:String, className:String):Class
		{
			var domain:ApplicationDomain = _domains[source];
			
			if(domain &&  domain.hasDefinition(className) ) return domain.getDefinition(className) as Class;
			return null;
		}
		
		public static function getAtlas(name:String):AtlasAsset
		{
			return _atlassList[name];
		}
		
		public static function getText(name:String):String
		{
			return _textList[name];
		}
		
		
		public static function loadAtlas(xmlURL:String, atlasName:String):AtlasLoader
		{
			var atlasLoader:AtlasLoader = new AtlasLoader(atlasName);
			atlasLoader.addEventListener(Event.COMPLETE, handlerAtlasLoadComplete);
			atlasLoader.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadAtlas);
			atlasLoader.loadAtlas( xmlURL );
			return atlasLoader;
		}
		
		private static function handlerAtlasLoadComplete(e:Event):void
		{
			var atlasLoader:AtlasLoader = e.currentTarget as AtlasLoader;
			
			atlasLoader.removeEventListener(Event.COMPLETE, handlerAtlasLoadComplete);
			atlasLoader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadAtlas);
			
			var atlas:AtlasAsset = new AtlasAsset();
			atlas.bitmapData = atlasLoader.getImage();
			atlas.xml = new XML(atlasLoader.getXML());
			atlas.name = atlasLoader.getAtlasName();
			
			_atlassList[atlasLoader.getAtlasName()] = atlas;
			
			atlasLoader.destroy();
		}
		
		private static function handlerErrorLoadAtlas(e:IOErrorEvent):void
		{
			var atlasLoader:AtlasLoader = e.currentTarget as AtlasLoader;
			
			atlasLoader.removeEventListener(Event.COMPLETE, handlerAtlasLoadComplete);
			atlasLoader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorLoadAtlas);
			
			atlasLoader.destroy();
		}
		
		
		
		public static function loadText(url:String, path:String):URLLoader
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handlerTextLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handlerTextErrorLoad);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load( new URLRequest(url) );
			
			_textList[loader] = path;
			
			return loader;
		}
		
		private static function handlerTextLoad(e:Event):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			
			loader.removeEventListener(Event.COMPLETE, handlerTextLoad);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handlerTextErrorLoad);
			
			var path:String = _textList[loader];
			delete _textList[loader];
			
			_textList[path] = loader.data;
		}
		
		private static function handlerTextErrorLoad(e:IOErrorEvent):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			
			loader.removeEventListener(Event.COMPLETE, handlerTextLoad);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handlerTextErrorLoad);
			
			delete _textList[loader];
		}
	}
}