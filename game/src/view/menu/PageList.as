package view.menu
{
	import flash.utils.Dictionary;
	
	import view.menu.settings.GameSettingsPage;
	import view.menu.start.StartPageMenu;

	public class PageList
	{
		public static const START_PAGE:				String = "start_page";
		public static const SINGLE_GAME_SETTINGS:	String = "single_game_settings";
		
		public static const PAGES:Dictionary = new Dictionary();
		PAGES[START_PAGE] = StartPageMenu;
		PAGES[SINGLE_GAME_SETTINGS] = GameSettingsPage;
	}
}