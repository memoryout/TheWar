package main.view
{
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	
	import main.MainGlobalVariables;
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.events.ApplicationEvents;
	import main.view.application.ApplicationRootContext;
	import main.view.application.asset.AssetManager;
	
	public class ApplicationMainLayoutModule extends Module implements IViewStartupProcess
	{
		public static const MODULE_NAME:		String = "app.view.main-layout";
		
		private var _mainLayout:				ApplicationMainLayout;
		private var _rootContext:				ApplicationRootContext;
		
		public function ApplicationMainLayoutModule()
		{
			super(this);
		}
		
		public function initialize(stage:Stage):void
		{
			_mainLayout = new ApplicationMainLayout();
			stage.addChild( _mainLayout );
		}
		
		
		override public function receiveMessage(message:MessageData):void
		{
			switch(message.message)
			{
				case ApplicationEvents.BOOT_COMPLETE:
				{
					_mainLayout.initialize();
					
					loadUIAsset();
					break;
				}
			}
		}
		
		private function loadUIAsset():void
		{
			var loaderInfo:LoaderInfo = AssetManager.loadAsset(MainGlobalVariables.SOURCE_URL, "ui");
			loaderInfo.addEventListener(Event.INIT, handlerUIAssetLoadComplete);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handlerUIAssetLoadError);
		}
		
		private function handlerUIAssetLoadComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerUIAssetLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerUIAssetLoadError);
			
			createRootContext();
		}
		
		private function handlerUIAssetLoadError(e:IOErrorEvent):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.INIT, handlerUIAssetLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handlerUIAssetLoadError);
		}
		
		private function createRootContext():void
		{
			_rootContext = new ApplicationRootContext();
			_rootContext.init( _mainLayout );
		}
	}
}