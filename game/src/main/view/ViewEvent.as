package main.view
{
	import main.broadcast.UniqueId;

	public class ViewEvent
	{
		public static const START_SINGLE_GAME:	String = UniqueId.create();
		
		public static const SET_ACTION:			String = UniqueId.create();
		public static const GET_ACTION_DATA:	String = UniqueId.create();
		
		public static const OPEN_NEW_GAME_PAGE:	String = UniqueId.create();
		public static const OPEN_LOAD_GAME_PAGE:String = UniqueId.create();
		public static const OPEN_SCENARION_PAGE:String = UniqueId.create();		
		public static const OPEN_CREDITS_PAGE:	String = UniqueId.create();		
	}
}