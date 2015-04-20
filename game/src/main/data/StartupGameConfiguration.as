package main.data
{
	public class StartupGameConfiguration
	{
		private static const _instance	:StartupGameConfiguration = new StartupGameConfiguration();
		
		public var scenario:			uint = 0;
		public var civilization:		uint = 0;
		public var level:				uint = 1; /// 0,1,2 (Low, Middle,High)
		public var map:					uint = 0;
		public var enemies:				uint = 0;
		
		public var civilizationName:	String;
		public var mapName:				String;
		
		
		public var randomPlacement:		Boolean;
		public var randomFill:			Boolean;
				
		public function StartupGameConfiguration()
		{
		}
		
		public static function Get():StartupGameConfiguration
		{
			return _instance;
		}
	}
}