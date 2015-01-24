package main.view
{
	import main.view.interfaces.IApplicationMenu;
	import main.view.interfaces.game.IMainGameView;
	import main.view.interfaces.preloader.IGamePreloaderScreenView;

	public interface IRootLayout
	{
		function initialize():void;
		
		function getMenuView():IApplicationMenu;
		function showApplicationMenu():void;
		function hideApplicationMenu():void;
		
		
		function getLoaderScreen():IGamePreloaderScreenView;
		function removeLoaderScreen():void;
		
		function getMainGameView():IMainGameView;
	}
}