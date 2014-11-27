package main.data
{
	public class ScenarioInfo
	{
		public var id:				Number = 0;
		public var name:			String;
		public var mapId:			uint;
		
		public var civilizations:Vector.<CivilizationInfo> = new Vector.<CivilizationInfo>();
		
		public function ScenarioInfo()
		{
		}
	}
}