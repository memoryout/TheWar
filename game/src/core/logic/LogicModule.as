package core.logic
{
	import core.logic.action.ActionsCreator;
	import core.logic.action.ActionsUpdater;
	import core.logic.ai.AILogic;
	import core.logic.data.CivilizationInListOfOrder;
	import core.logic.data.StateOfCivilization;
	import core.logic.data.StateOfProvince;
	import core.logic.events.CoreEvents;
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.data.CivilizationInfo;
	import main.data.DataContainer;
	import main.data.ProvinceInfo;
	import main.data.ScenarioInfo;
	import main.data.StartupGameConfiguration;
	import main.events.ApplicationEvents;
	import main.view.ViewEvent;
	
	public class LogicModule extends Module
	{
		public static const MODULE_NAME:		String = "CoreLogic";
		
		private var actionsCreator:		ActionsCreator;
		private var actionsUpdater:		ActionsUpdater;
		
		
		public function LogicModule()
		{
			super(this);
			
			actionsCreator = new ActionsCreator(sendMessage);
			actionsUpdater = new ActionsUpdater();
		}
		
		private function setMainVariables():void
		{
			LogicData.Get().selectedScenario		= StartupGameConfiguration.Get().scenario;
			LogicData.Get().selectedCivilization 	= StartupGameConfiguration.Get().civilization
			LogicData.Get().gameLevel 				= StartupGameConfiguration.Get().level;
			LogicData.Get().randomFill 				= StartupGameConfiguration.Get().randomFill;
			LogicData.Get().randomPlacement 		= StartupGameConfiguration.Get().randomPlacement;
		}
		
		/**
		 * Creation of civilization object with province wich contains. 
		 */		
		private function locateCivilizationOnPositions():void
		{
			var scenario:ScenarioInfo = DataContainer.Get().getScenario(LogicData.Get().selectedScenario);
			
			LogicData.Get().mapId = scenario.mapId;			
			
			var provincesList:Vector.<ProvinceInfo> = DataContainer.Get().getMapsList()[scenario.mapId].provinces;			
			var initScenarioCivilizations:Vector.<CivilizationInfo> = DataContainer.Get().getScenariousList()[LogicData.Get().selectedScenario].civilizations;
			
			for (var i:int = 0; i < initScenarioCivilizations.length; i++) 
			{
				var stateOfCivilization:StateOfCivilization = new StateOfCivilization();
					
				LogicData.Get().aiLogicContainer.push(new AILogic(stateOfCivilization));
				
				for (var j:int = 0; j < provincesList.length; j++) 
				{				
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
						LogicData.Get().provincesList.push(province);
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
		
		private function updateTotalBonusFromCraftingForEachCivilization():void
		{
			
		}		
		
		/**
		 * Ежедневный доход (Daliy Income) = BV + TBC + TB * nT + D;
			
			BV (Basic Value) - начальное значение количества монет для конкретной территории.
				
			TBC (Total Bonus from Crafting) – сумма всех улучшений купленных в Дереве технологий, дающих 
			
			прирост дохода.
				
			TB (Temple Bonus) – бонус за наличие храма.
				
			nT (Temple Number) – количество храмов.
			diplomacy 		   - дипломатия.
		 * 
		 */		
		private function updateCivilizationsMoney():void
		{
			for (var i:int = 0; i < LogicData.Get().civilizationList.length; i++) 
			{
				updateTotalBonusFromCraftingForEachCivilization();
								
				for (var j:int = 0; j < LogicData.Get().civilizationList[i].provinces.length; j++) 
				{
					var provinceIncome:Number = 0;
					var templateBonus:Number  = 0;
					
					if(LogicData.Get().civilizationList[i].provinces[j].buildingList.indexOf(ConstantParameters.TEMPLATE) != -1)
						templateBonus = ConstantParameters.TEMPLATE_BONUS;	
					
					provinceIncome = LogicData.Get().civilizationList[i].provinces[j].moneyGrowth + LogicData.Get().civilizationList[i].totalBonusFromCrafting + templateBonus;
					
					LogicData.Get().civilizationList[i].money += LogicData.Get().civilizationList[i].totalBonusFromCrafting + LogicData.Get().civilizationList[i].totalBonusFromDiplomacyTrade + provinceIncome;
					
					sendMessage(ApplicationEvents.SHOW_MESSAGE, "civilization: " + LogicData.Get().civilizationList[i].name);
					sendMessage(ApplicationEvents.SHOW_MESSAGE, "money: " 		 + LogicData.Get().civilizationList[i].money);
				}				
			}			
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
		
		
		
		override public function listNotificationInterests():Array
		{
			return [
					ApplicationEvents.DATA_SAVED,
					ViewEvent.START_SINGLE_GAME,
					CoreEvents.GET_CIVILIZATION_ORDER,
					CoreEvents.GET_TREASURE,
					CoreEvents.GET_STATISTIC,
					CoreEvents.FINISH_STEP,
					ViewEvent.SET_ACTION
			];
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
					setMainVariables();
					locateCivilizationOnPositions();
					break;
				}
									
				case CoreEvents.GET_CIVILIZATION_ORDER:
				{					
					actionsUpdater.update();
					updateCivilizationsMoney();
					
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
					
				case ViewEvent.SET_ACTION:
				{
					actionsCreator.create(message.data);
					break;
				}
			}
		}
	}
}