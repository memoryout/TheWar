package main.view.application.asset
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	public class AssetManager
	{
		private static const _domains:			Dictionary = new Dictionary();
		
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
	}
}