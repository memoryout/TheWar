package main.view.application.menu
{
	import flash.utils.Dictionary;
	
	import main.view.application.menu.game_civ_order.GameCivOrder;
	import main.view.application.menu.game_step_statistics.GameStepStatistic;
	import main.view.application.menu.game_treasure.GameTreasureInfo;
	import main.view.application.menu.settings.GameSettingsPage;
	import main.view.application.menu.start.StartPageMenu;

	public class PageList
	{
		public static const START_PAGE:				String = "start_page";
		public static const SINGLE_GAME_SETTINGS:	String = "single_game_settings";
		public static const GAME_CIV_ORDER:			String = "game_civ_order";
		public static const GAME_TREASURE:			String = "game_treasure";
		public static const GAME_STEP_STATISTICS:	String = "game_step_statistics";
		
		public static const PAGES:Dictionary = new Dictionary();
		PAGES[START_PAGE] = StartPageMenu;
		PAGES[SINGLE_GAME_SETTINGS] = GameSettingsPage;
		PAGES[GAME_CIV_ORDER] = GameCivOrder;
		PAGES[GAME_TREASURE] = GameTreasureInfo;
		PAGES[GAME_STEP_STATISTICS] = GameStepStatistic;
	}
}