package main.view.application.data.game
{
	import core.logic.data.StateOfCivilization;

	public class Civilization
	{
		private var _data:				StateOfCivilization;
		
		private var _defaultColor:		int;
		
		public function Civilization(data:StateOfCivilization)
		{
			_data = data;
		}
		
		
		public function setColor(color:int):void
		{
			_defaultColor = color;
		}
		
		public function getColor():int
		{
			return _defaultColor;
		}
	}
}