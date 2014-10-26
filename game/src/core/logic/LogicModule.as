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
	
	import utils.updater.Updater;

	public class LogicModule extends Module
	{
		public static const MODULE_NAME:		String = "CoreLogic";
		
		private var regionsData:Vector.<Region> = new Vector.<Region>();
		
		private var stackAction:Array = new Array();
		
		public function LogicModule()
		{
			setSharedModule( MODULE_NAME, this );
			
			Updater.get().addListener(updateStack);
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
			
			sendMessage(CoreEvents.CIVILIZATIONS_LOCATED, LogicData.Get().locatedRegions);
		}
		
		private function updateStack(e:Object):void
		{
			if(stackAction.length > 0)
			{
				determinateMethod(stackAction[0][0], stackAction[0][1]);
				stackAction.shift();
			}
		}
		
		private function determinateMethod(name:String, data:Object):void
		{
			switch(name)
			{
				case "init":
				{
					setMainVariables(data);
					locateCivilizationOnPositions();
					break;
				}
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
					
				case ViewEvent.START_SINGLE_GAME:
				{
					stackAction.push(["init", message.data]);
				}
			}
		}
	}
}