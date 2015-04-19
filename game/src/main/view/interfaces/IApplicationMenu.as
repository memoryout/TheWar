package main.view.interfaces
{
	import main.view.interfaces.menu.IViewMenuStartPage;

	public interface IApplicationMenu
	{
		function initialize(onComplete:Function):void;
		function showBackground():void;
		function unload():void;
		
		function showStartPage()				:IViewMenuStartPage;
		function showNewGamePage()				:IViewMenuStartPage;
		function showScenarioPage()				:IViewMenuStartPage;		
		function showCivilizationsPage()		:IViewMenuStartPage;			
		
		function showMapPage()					:IViewMenuStartPage;		
		function showLevelPage()				:IViewMenuStartPage;	
		function showScenarioSettingsPage()		:IViewMenuStartPage;	
	}
}