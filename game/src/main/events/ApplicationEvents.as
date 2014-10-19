package main.events
{
	import main.broadcast.UniqueId;

	public class ApplicationEvents
	{
		public static const SOURCES_LOADED:					String = UniqueId.create();		
		public static const CONFIG_LOADED:					String = UniqueId.create();		
	}
}