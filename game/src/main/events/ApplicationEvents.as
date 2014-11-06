package main.events
{
	import main.broadcast.UniqueId;

	public class ApplicationEvents
	{
		public static const BOOT_COMPLETE:				String = UniqueId.create();
		
		public static const SOURCES_LOADED:				String = UniqueId.create();		
		public static const CONFIG_LOADED:				String = UniqueId.create();		
		public static const PARSE_CONFIG:				String = UniqueId.create();		
		public static const DATA_SAVED:					String = UniqueId.create();		
		
		public static const GET_REGIONS_DATA:			String = UniqueId.create();		
	}
}