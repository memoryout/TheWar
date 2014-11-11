package main.view
{
	import main.broadcast.UniqueId;

	public class ViewEvent
	{
		public static const START_SINGLE_GAME:	String = UniqueId.create();
		
		public static const SET_ACTION:			String = UniqueId.create();
		public static const GET_ACTION_DATA:	String = UniqueId.create();
	}
}