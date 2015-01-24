package main.view
{
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import main.MainGlobalVariables;
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.events.ApplicationEvents;
	import main.view.application.ApplicationMainController;
	import main.view.application.asset.AssetManager;
	import main.view.loader.ResourceLoader;
	import main.view.loader.ResourceType;
	import main.view.starling.sApplicationRootLayout;
	import main.view.starling.sScreenUtils;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class StarlingBootModule extends Module implements IViewStartupProcess
	{
		public static const MODULE_NAME:		String = "app.view.startup_process";
		
		private var _starling:			Starling;
		
		private var _rootLayout:		sApplicationRootLayout;
		
		private var _assetLoadStatus:	int;
		
		public function StarlingBootModule()
		{
			this.setSharedModule(MODULE_NAME, this);
			
			_assetLoadStatus = 0;
		}
		
		public function initialize(stage:Stage):void
		{
			var rect:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			if(rect.width < rect.height) 
			{
				rect.x = rect.width;
				rect.width = rect.height;
				rect.height = rect.x;
				rect.x = 0;
			}
			
			sScreenUtils.calculateResourceSize(stage);
			
			_starling = new Starling(sApplicationRootLayout, stage, rect);
			_starling.addEventListener(Event.ROOT_CREATED, handlerRootCreated);
			_starling.start();
		}
		
		private function handlerRootCreated(e:Event):void
		{
			_rootLayout = _starling.root as sApplicationRootLayout;
			
			startApplication();
		}
		
		
		private function loadUIAsset():void
		{
			var loader:ResourceLoader = new ResourceLoader();
			loader.addToLoadList(MainGlobalVariables.SOURCE_STARLING_MAIN_URL, "ui", ResourceType.SWF);
			loader.addToLoadList("data/starling/starling_library.xml", "ui_library", ResourceType.ATLAS);
			loader.startLoad( onLoadUIAsset, onErrorLoadUIAsset);
		}
		
		private function onLoadUIAsset():void
		{
			_assetLoadStatus = 1;
			startApplication();
		}
		
		private function onErrorLoadUIAsset():void
		{
			_assetLoadStatus = -1;
			startApplication();
		}
		
		
		private function startApplication():void
		{
			if(_rootLayout) 
			{
				if(_assetLoadStatus > 0)
				{
					new ApplicationMainController().initialize( _rootLayout );
					this.destroy();
				}
				else if(_assetLoadStatus < 0) trace("show error message");//show error message;
			}
		}
		
		
		override public function receiveMessage(message:MessageData):void
		{
			switch(message.message)
			{
				case ApplicationEvents.BOOT_COMPLETE:
				{
					loadUIAsset();
					break;
				}
			}
		}
	}
}