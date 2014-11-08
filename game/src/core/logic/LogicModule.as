package core.logic
{
	import core.logic.data.CivilizationInListOfOrder;
	import core.logic.data.StateOfCivilization;
	import core.logic.data.StateOfProvince;
	import core.logic.events.CoreEvents;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.data.CivilizationInfo;
	import main.data.DataContainer;
	import main.data.MapInfo;
	import main.data.ProvinceInfo;
	import main.data.ScenarioInfo;
	import main.events.ApplicationEvents;
	import main.view.ViewEvent;

	public class LogicModule extends Module
	{
		public static const MODULE_NAME:		String = "CoreLogic";
		
		private var regionsData:Vector.<ProvinceInfo> = new Vector.<ProvinceInfo>();
		
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
		
		/**
		 * Creation of civilization object with province wich contains. 
		 */		
		private function locateCivilizationOnPositions():void
		{
			var provincesList:Vector.<ProvinceInfo> = DataContainer.Get().getMapsList()[LogicData.Get().selectedScenario].provinces;			
			var initScenarioCivilizations:Vector.<CivilizationInfo> = DataContainer.Get().getScenariousList()[LogicData.Get().selectedScenario].civilizations;
			
			for (var i:int = 0; i < initScenarioCivilizations.length; i++) 
			{
				for (var j:int = 0; j < provincesList.length; j++) 
				{
					var stateOfCivilization:StateOfCivilization = new StateOfCivilization();
					
					if(provincesList[j].id == initScenarioCivilizations[i].province)
					{						
						stateOfCivilization.id 				= initScenarioCivilizations[i].id;
						stateOfCivilization.flag 			= initScenarioCivilizations[i].flag;						
						stateOfCivilization.money 			= initScenarioCivilizations[i].money;
						stateOfCivilization.name			= initScenarioCivilizations[i].name;
						
						var province:StateOfProvince = new StateOfProvince();
						
						province.id 				= provincesList[j].id;
						province.moneyGrowth 		= provincesList[j].moneyGrowth;
						province.neighboringRegions = provincesList[j].neighboringRegions;
						
						stateOfCivilization.provinces.push(province);
						
						LogicData.Get().civilizationList.push(stateOfCivilization);
					}
				}				
			}
			
			sendMessage(CoreEvents.GAME_READY, LogicData.Get().civilizationList);
		}
		
		/** 
		 * Set random order list woth civilization action.
		 */		
		private function getRandomCivilizationOrderList():void
		{
			LogicData.Get().listOfOrder = new Vector.<CivilizationInListOfOrder>();
			
			var civilizationsContainer:Vector.<StateOfCivilization> = LogicData.Get().civilizationList.concat();
			
			while(civilizationsContainer.length > 0)
			{
				var randNumber:int 							= Math.random()*civilizationsContainer.length;
				var singleInList:CivilizationInListOfOrder 	= new CivilizationInListOfOrder();
				
				singleInList.id		= civilizationsContainer[randNumber].id;
				singleInList.flag	= civilizationsContainer[randNumber].flag;
				singleInList.name	= civilizationsContainer[randNumber].name;
				
				if(singleInList.id == LogicData.Get().selectedCivilization)
					singleInList.chosenCiviliztion	= true;
				
				LogicData.Get().listOfOrder.push(singleInList);
				
				civilizationsContainer.splice(randNumber, 1);
			}			
		}
		
		private function updateTotalBonusFromCrafting():void
		{
			
		}
		
		private function updateStateOfCivilization():void
		{
						
		}
		
		private function defineSteps():void
		{
			switch(LogicData.Get().currentStep)
			{
				case CoreEvents.USER_ACTIVITY:
				{				
					LogicData.Get().currentStep = CoreEvents.CIVILIZATION_ORDER;
					
					break;
				}
					
				case CoreEvents.CIVILIZATION_ORDER:
				{							
					LogicData.Get().currentStep = CoreEvents.TREASURE;
					
					break;
				}
					
				case CoreEvents.TREASURE:
				{					
					LogicData.Get().currentStep = CoreEvents.STATISTIC;
					
					break;
				}
					
				case CoreEvents.STATISTIC:
				{	
					LogicData.Get().currentStep = CoreEvents.USER_ACTIVITY;
					
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
//					locateCivilizationOnPositions();
					break;
				}
					
				case ViewEvent.START_SINGLE_GAME:
				{
					setMainVariables(message.data);
					locateCivilizationOnPositions();
					break;
				}
									
				case CoreEvents.GET_CIVILIZATION_ORDER:
				{
					defineSteps();				
					
					getRandomCivilizationOrderList();
					
					sendMessage(CoreEvents.SEND_CIVILIZATION_ORDER, LogicData.Get().listOfOrder);
					break;
				}
					
				case CoreEvents.GET_TREASURE:
				{
					defineSteps();
					sendMessage(CoreEvents.SEND_TREASURE, []);
					
					break;
				}
					
				case CoreEvents.GET_STATISTIC:
				{
					defineSteps();
					sendMessage(CoreEvents.SEND_STATISTIC, []);
					break;
				}
					
				case CoreEvents.FINISH_STEP:
				{
					defineSteps();
					break;
				}
			}
		}
	}
}