package main.view.application.menu
{
	import flash.utils.Dictionary;
	
	import main.view.application.menu.settings.GameSettingsPage;
	import main.view.application.menu.start.StartPageMenu;

	public class PageList
	{
		public static const START_PAGE:				String = "start_page";
		public static const SINGLE_GAME_SETTINGS:	String = "single_game_settings";
		
		public static const PAGES:Dictionary = new Dictionary();
		PAGES[START_PAGE] = StartPageMenu;
		PAGES[SINGLE_GAME_SETTINGS] = GameSettingsPage;
	}
}