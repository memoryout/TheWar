package core.data
{
	public class DataContainer
	{
		private static const _instance	:DataContainer = new DataContainer();
		
		public var regionsDataContainer:Vector.<Region> = new Vector.<Region>();
		public var civilizationsDataContainer:Vector.<Civilization> = new Vector.<Civilization>();
		
		public function DataContainer()
		{
		}
		
		public static function Get():DataContainer
		{
			return _instance;
		}
		
		public function addRegion(val:Region):void
		{
			regionsDataContainer.push(val);
		}
		
		
		public function addCivilization(val:Civilization):void
		{
			civilizationsDataContainer.push(val);
		}			
	}
}