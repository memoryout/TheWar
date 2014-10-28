package core.logic.events
{
	import main.broadcast.UniqueId;

	public class CoreEvents
	{
		public static const CIVILIZATIONS_LOCATED:	String = UniqueId.create();		
		public static const GAME_READY:				String = UniqueId.create();		
	}
}