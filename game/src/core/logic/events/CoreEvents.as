package core.logic.events
{
	import main.broadcast.UniqueId;

	public class CoreEvents
	{
		public static const CIVILIZATIONS_LOCATED:	String = UniqueId.create();		
		public static const GAME_READY:				String = UniqueId.create();		
		
		public static const FINISH_STEP:			String = UniqueId.create();		
		
		public static const GET_CIVILIZATION_ORDER:	String = UniqueId.create();		
		public static const GET_TREASURE:			String = UniqueId.create();		
		public static const GET_STATISTIC:			String = UniqueId.create();		
		
		public static const SEND_CIVILIZATION_ORDER:String = UniqueId.create();		
		public static const SEND_TREASURE:			String = UniqueId.create();		
		public static const SEND_STATISTIC:			String = UniqueId.create();		
		
		
		public static const USER_ACTIVITY:			String = "user_activity";	
		public static const CIVILIZATION_ORDER:		String = "civilization_order"
		public static const TREASURE:				String = "treasure";		
		public static const STATISTIC:				String = "statistic";	
	}
}