package core.logic
{
	import core.logic.events.CoreEvents;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.data.Civilization;
	import main.data.DataContainer;
	import main.data.Region;
	import main.data.Scenario;
	import main.events.ApplicationEvents;
	import main.view.ViewEvent;

	public class LogicModule extends Module
	{
		public static const MODULE_NAME:		String = "CoreLogic";
		
		private var regionsData:Vector.<Region> = new Vector.<Region>();
		
		public function LogicModule()
		{
			setSharedModule( MODULE_NAME, this );
		}
		
		private function setMainVariables(val:Object):void
		{
			LogicData.Get().selectedScenario		= val.scenario;
			LogicData.Get().selectedCivilization 	= val.civilization;
			LogicData.Get().gameLevel 				= val.level;
			LogicData.Get().randomFill 				= val.randomFill;
			LogicData.Get().randomPlacement 		= val.randomPlacement;
		}
		
		private function locateCivilizationOnPositions():void
		{
			var initRegions:Vector.<Region> = DataContainer.Get().regions.concat();			
			var initScenarioCivilizations:Vector.<Civilization> = DataContainer.Get().scenarios[LogicData.Get().selectedScenario].civilizations;
			
			for (var i:int = 0; i < initScenarioCivilizations.length; i++) 
			{
				for (var j:int = 0; j < initRegions.length; j++) 
				{
					if(initRegions[j].id == initScenarioCivilizations[i].region)
					{
						initRegions[j].money 		= initScenarioCivilizations[i].money;
						initRegions[j].population 	= initScenarioCivilizations[i].population;
						initRegions[j].civilization	= initScenarioCivilizations[i].name;
					}
					
					LogicData.Get().locatedRegions.push(initRegions[j]);
				}				
			}
			
			sendMessage(CoreEvents.GAME_READY, LogicData.Get().locatedRegions);
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
					
				case ViewEvent.START_SINGLE_GAME:
				{
					setMainVariables(message.data);
					locateCivilizationOnPositions();
				}
			}
		}
	}
}