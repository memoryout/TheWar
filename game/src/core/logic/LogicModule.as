package core.logic
{
	import core.logic.action.GameActionBuild;
	import core.logic.action.GameActionBuyTechnology;
	import core.logic.action.GameActionByArmy;
	import core.logic.action.GameActionMoveArmy;
	import core.logic.action.GameActionUnionAnswer;
	import core.logic.action.GameActionUnionCancel;
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
	
	import mx.core.mx_internal;

	public class LogicModule extends Module
	{
		public static const MODULE_NAME:		String = "CoreLogic";
		
		private var regionsData:Vector.<ProvinceInfo> = new Vector.<ProvinceInfo>();
		
		private var stackAction:Array = new Array();
		
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
		
		private function setAction(action:Object):void
		{
			var currentCivilization:StateOfCivilization = LogicData.Get().civilizationList[LogicData.Get().selectedCivilization];
			var provincesList:Vector.<StateOfProvince>  = LogicData.Get().provincesList;
			var currentProvince:StateOfProvince, i:int;	
						
			if(action.type == ConstantParameters.BUY_ARMY)			
			{				
				// find province
				for (i = 0; i < currentCivilization.provinces.length; i++) 
				{								
					if(currentCivilization.provinces[i].id == action.sourceRegionID)
					{
						currentProvince = currentCivilization.provinces[i];
						break;	
					}
				}				
				
				// set by army action
				var gameAction:GameActionByArmy = new GameActionByArmy();
				
				gameAction.amount 			= currentProvince.armyNumber + action.amount;
				gameAction.type 			= ConstantParameters.BUY_ARMY;
				gameAction.sourceRegionID	= action.sourceRegionID;
				
				gameAction.stepsLeft = 1; // need change
				
				stackAction.push(gameAction);
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameAction);
				
			}else if(action.type == ConstantParameters.MOVE_ARMY){
				
				var gameActionMove:GameActionMoveArmy = new GameActionMoveArmy();		
				
				for (var j:int = 0; j < provincesList.length; j++) 
				{
					if(provincesList[j].id == action.sourceRegionID)					
						gameActionMove.sourceRegionId 		= action.sourceRegionID;					
					
					else if(provincesList[j].id == action.destinationRegionId)					
						gameActionMove.destinationRegionId  = action.destinationRegionId;					
				}
				
				gameActionMove.amount = action.amount;
				gameActionMove.type = ConstantParameters.MOVE_ARMY;
				
				gameActionMove.stepsLeft = 1; // need change ?
													
				stackAction.push(gameActionMove);
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionMove);
				
			}else if(action.type == ConstantParameters.BUILD){
				
				var gameActionBuild:GameActionBuild = new GameActionBuild();
				
				for (i = 0; i < currentCivilization.provinces.length; i++) 
				{								
					if(currentCivilization.provinces[i].id == action.destinationRegionId)
					{
						currentCivilization.provinces[i].buildProcess.current += 1;
						
						//// need get total step to bild
						
						if(currentCivilization.provinces[i].buildProcess.current == currentCivilization.provinces[i].buildProcess.total)
						{
							currentCivilization.provinces[i].buildingList.push(action.buildingId);
							currentCivilization.provinces[i].buildProcess.current = 0;
						}
							
						gameActionBuild.buildingId = action.buildingId;
						gameActionBuild.destinationRegionId = action.destinationRegionId;
					}
				}
				
				gameActionBuild.type = ConstantParameters.BUILD;
				gameActionBuild.stepsLeft = 1; // need change
				
				stackAction.push(gameActionBuild);		
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionBuild);
				
			}else if(action.type == ConstantParameters.BUY_TECHNOLOGY){
				
				var gameActionByTechnology:GameActionBuyTechnology = new GameActionBuyTechnology();
				gameActionByTechnology.type = ConstantParameters.BUY_TECHNOLOGY;
				gameActionByTechnology.technologyId = action.technologyId;
				gameActionByTechnology.stepsLeft = 1; // need change
				
				stackAction.push(gameActionByTechnology);			
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionByTechnology);
				
			}else if(action.type == ConstantParameters.UNION_OFFER){
				
				var gameActionUnionOffer:GameActionUnionAnswer = new GameActionUnionAnswer();
				gameActionUnionOffer.type = ConstantParameters.UNION_OFFER;
				
				gameActionUnionOffer.targetCivilizationId = action.targetCivilizationId;
				gameActionUnionOffer.sourceCivilizationId = action.sourceCivilizationId;
				gameActionUnionOffer.stepsLeft = 1; // need change
				
				stackAction.push(gameActionUnionOffer);				
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionUnionOffer);
				
			}else if(action.type == ConstantParameters.UNION_OFFER_ANSWER){
				
				
				
			}else if(action.type == ConstantParameters.UNION_CANCEL){
				
								
			}			
		}
		
		private function updateStackAction():void
		{		
				
			for (var i:int = 0; i < stackAction.length; i++) 
			{
				if(stackAction[i])
				{
					var currentCivilization:StateOfCivilization = LogicData.Get().civilizationList[LogicData.Get().selectedCivilization];
					var provincesList:Vector.<StateOfProvince>  = LogicData.Get().provincesList;
										
					if(stackAction[i].type == ConstantParameters.BUY_ARMY)
					{
						// find province
						for (i = 0; i < currentCivilization.provinces.length; i++) 
						{								
							if(currentCivilization.provinces[i].id == stackAction[i].sourceRegionID)
							{
								currentCivilization.provinces[i].armyNumber += stackAction[i].amount;								
								break;	
							}
						}		
						
					}else if(stackAction[i].type == ConstantParameters.MOVE_ARMY)
					{
						for (var j:int = 0; j < provincesList.length; j++) 
						{
							if(provincesList[j].id == stackAction[i].sourceRegionId && provincesList[j].armyNumber >= stackAction[i].amount)
							{
								provincesList[j].armyNumber -= stackAction[i].amount;
							}
							else if(provincesList[j].id == stackAction[i].destinationRegionId)
							{								
								provincesList[j].armyNumber += stackAction[i].amount;
							}
						}
					}else if(stackAction[i].type == ConstantParameters.BUILD)
					{
						
						
					}else if(stackAction[i].type == ConstantParameters.BUY_ARMY)
					{
						
					}						
					
					stackAction[i].stepsLeft--;
					
					if(stackAction[i].stepsLeft==0)
					{
						stackAction[i] = null;							
					}
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
					updateStackAction();
					
					defineSteps();				
					
					getRandomCivilizationOrderList();
					
					sendMessage(CoreEvents.SEND_CIVILIZATION_ORDER, LogicData.Get().listOfOrder);
					break;
				}
					
				case CoreEvents.GET_TREASURE:
				{	
//					updateStackAction();
					updateCivilizationsMoney();
					
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
					setAction(message.data);
					break;
				}
			}
		}
	}
}