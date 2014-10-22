package core.logic
{
	import core.data.DataContainer;
	import core.data.Region;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.events.ApplicationEvents;

	public class LogicModule extends Module
	{
		public static const MODULE_NAME:		String = "CoreLogic";
		
		private var regionsData:Vector.<Region> = new Vector.<Region>();
		
		public function LogicModule()
		{
			setSharedModule( MODULE_NAME, this );
		}
		
		private function locateCivilizationOnPositions():void
		{
			for (var i:int = 0; i < DataContainer.Get().civilizationsDataContainer.length; i++) 
			{
				var randNumber:int = Math.random()*DataContainer.Get().civilizationsDataContainer.length;
				
//				DataContainer.Get().civilizationsDataContainer[].
				
//				DataContainer.Get().regionsDataContainer[randNumber].army = DataContainer.Get().civilizationsDataContainer[randNumber].
			}			
		}
		
		override public function receiveMessage(message:MessageData):void
		{		
			switch(message.message)
			{
				case ApplicationEvents.DATA_SAVED:
				{
					locateCivilizationOnPositions();
					break;
				}	
					
				case ApplicationEvents.GET_REGIONS_DATA:
				{
					
				}
			}
		}
	}
}