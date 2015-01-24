package main.view.interfaces.preloader
{
	import main.view.interfaces.IViewObject;

	public interface IGamePreloaderScreenView extends IViewObject
	{
		function setProgress(progress:Number):void;
		function destroy():void;
	}
}