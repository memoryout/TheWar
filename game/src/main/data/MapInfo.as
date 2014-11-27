package main.data
{
	public class MapInfo
	{
		public var id:				Number = 0;
		public var name:			String;
		public var sourceLink:		String;
		
		public var tileXNum:		uint;
		public var tileYNum:		uint;
		
		public var provinces:Vector.<ProvinceInfo> = new Vector.<ProvinceInfo>();
	}
}