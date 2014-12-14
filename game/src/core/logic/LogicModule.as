package core.logic
{
	import core.logic.action.GameAction;
	import core.logic.action.GameActionAskForUnionStatus;
	import core.logic.action.GameActionAttack;
	import core.logic.action.GameActionBuild;
	import core.logic.action.GameActionBuyTechnology;
	import core.logic.action.GameActionByArmy;
	import core.logic.action.GameActionMoveArmy;
	import core.logic.action.diplomacy.movement.GameActionArmyMovemenRequest;
	import core.logic.action.diplomacy.movement.GameActionArmyMovementAnswer;
	import core.logic.action.diplomacy.movement.InGameArmyMovementBroken;
	import core.logic.action.diplomacy.trading.GameActionTradingAnswer;
	import core.logic.action.diplomacy.trading.GameActionTradingRequest;
	import core.logic.action.diplomacy.trading.InGameTradingStatus;
	import core.logic.action.diplomacy.union.GameActionUnionStatusAnswer;
	import core.logic.action.diplomacy.union.GameActionUnionStatusBroken;
	import core.logic.action.diplomacy.union.GameActionUnionStatusRequest;
	import core.logic.action.diplomacy.union.InGameUnionComplete;
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
		
		private var stackActions:		Array = new Array();
		
		private var stackNotifications:	Array = new Array();
		
		
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
			var scenario:ScenarioInfo = DataContainer.Get().getScenario( LogicData.Get().selectedScenario );
			
			if(scenario == null)
			{
				// я запросил несуществующий сценарий.
				return;
			}
			
			LogicData.Get().mapId = scenario.mapId;
			
			
			var provincesList:Vector.<ProvinceInfo> = DataContainer.Get().getMapsList()[scenario.mapId].provinces;			
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
				for (i = 0; i < currentCivilization.provinces.length; i++) 
				{								
					if(currentCivilization.provinces[i].id == action.sourceRegionID)
					{
						currentProvince = currentCivilization.provinces[i];
						break;	
					}
				}								
			
				var priceArmy:Number = ConstantParameters.ARMY_PRICE*action.amount;
				
				var gameAction:GameActionByArmy = new GameActionByArmy();
				gameAction.type 				= ConstantParameters.BUY_ARMY;
				
				if(priceArmy <= currentCivilization.money)				
					gameAction.amount = currentProvince.armyNumber + action.amount;				
				
				gameAction.sourceRegionID		= action.sourceRegionID;				
				gameAction.stepsLeft 			= 1; 
				
				gameAction.id = LogicData.Get().actionCounter;
				
				stackActions.push(gameAction);
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameAction);
				
			}else if(action.type == ConstantParameters.MOVE_ARMY){
							
				var gameActionMove:GameActionMoveArmy 	= new GameActionMoveArmy();
				gameActionMove.type 					= ConstantParameters.MOVE_ARMY;
				
				for (i = 0; i < provincesList.length; i++) 
				{
					if(provincesList[i].id == action.sourceRegionID)					
					{
						gameActionMove.sourceRegionId 		= action.sourceRegionID;							
					}					
					else if(provincesList[i].id == action.destinationRegionId)					
					{
						gameActionMove.destinationRegionId  = action.destinationRegionId;							
					}
				}
				
				gameActionMove.amount 		= action.amount;		
				gameActionMove.stepsLeft 	= 1; 									// need change ?				
				gameActionMove.id 			= LogicData.Get().actionCounter;
																
				stackActions.push(gameActionMove);
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionMove);
				
			}else if(action.type == ConstantParameters.ATTACK){
				
				var attackCiv:StateOfCivilization  = findCurrentCivilizationAccodingProvince(action.sourceRegionID);
				var defenceCiv:StateOfCivilization = findCurrentCivilizationAccodingProvince(action.destinationRegionId);
				var attackProvince:StateOfProvince;
				var defenceProvince:StateOfProvince;
				
				var gameActionAttack:GameActionAttack 	= new GameActionAttack();
				gameActionAttack.type 					= ConstantParameters.ATTACK;
				
				for (i = 0; i < provincesList.length; i++) 
				{
					if(provincesList[i].id == action.sourceRegionID)					
					{
						gameActionAttack.sourceRegionId 		= action.sourceRegionID;
						attackProvince = provincesList[i];						
					}
						
					else if(provincesList[i].id == action.destinationRegionId)					
					{
						gameActionAttack.destinationRegionId  = action.destinationRegionId;		
						defenceProvince = provincesList[i];
					}
				}
							
				gameActionAttack.stepsLeft 		= 1; 									// need change ?				
				gameActionAttack.id 			= LogicData.Get().actionCounter;
				
				//// define who win battle				
				var delta:Number = defenceCiv.army.defence*defenceProvince.armyNumber - attackCiv.army.attack*attackProvince.armyNumber;
				
				if(delta >= 0)
					gameActionAttack.win = false;
				else if(delta < 0)						
					gameActionAttack.win = true;
				
				gameActionAttack.amount = Math.abs(delta);						
				///
				
				stackActions.push(gameActionAttack);
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionAttack);
				
			}else if(action.type == ConstantParameters.BUILD){
				
				var gameActionBuild:GameActionBuild = new GameActionBuild();
				gameActionBuild.type = ConstantParameters.BUILD;
				
				for (i = 0; i < currentCivilization.provinces.length; i++) 
				{								
					if(currentCivilization.provinces[i].id == action.destinationRegionId)
					{
						currentProvince = currentCivilization.provinces[i];
						break;	
					}
				}
				
				for (var k:int = 0; k < ConstantParameters.BUILDINGS.length; k++) 
				{
					if(ConstantParameters.BUILDINGS[k].id == action.buildingId)
					{
						currentProvince.buildProcess.total 	= ConstantParameters.BUILDINGS[k].totalStep;				
						gameActionBuild.stepsLeft 			= ConstantParameters.BUILDINGS[k].totalStep;
						break;
					}
				}			
				
				gameActionBuild.buildingId 			= action.buildingId;
				gameActionBuild.destinationRegionId = action.destinationRegionId;					
				gameActionBuild.id 					= LogicData.Get().actionCounter;
				
				stackActions.push(gameActionBuild);		
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionBuild);					
				
			}else if(action.type == ConstantParameters.BUY_TECHNOLOGY){
				
				var gameActionByTechnology:GameActionBuyTechnology 	= new GameActionBuyTechnology();
				gameActionByTechnology.type 						= ConstantParameters.BUY_TECHNOLOGY;
				gameActionByTechnology.technologyId 				= action.technologyId;
				
				for (var j:int = 0; j < DataContainer.Get().getTechnologiesList().length; j++) 
				{
					if(DataContainer.Get().getTechnologiesList()[j].id == action.technologyId)
					{
						gameActionByTechnology.stepsLeft = DataContainer.Get().getTechnologiesList()[j].steps;
							break;
					}
				}
					
				gameActionByTechnology.id = LogicData.Get().actionCounter;
				
				stackActions.push(gameActionByTechnology);			
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionByTechnology);
				
			}else if(action.type == ConstantParameters.UNION_STATUS_REQUEST)
			{
				var gameUnionRequest:GameActionUnionStatusRequest = new GameActionUnionStatusRequest();
				gameUnionRequest.type = ConstantParameters.UNION_STATUS_REQUEST;
				gameUnionRequest.id   = LogicData.Get().actionCounter;
				
				gameUnionRequest.sourceCivilizationId = action.targetCivilizationId;
				gameUnionRequest.targetCivilizationId = action.ourceCivilizationId;
				
				gameUnionRequest.union = action.union;
				gameUnionRequest.stepsLeft = 1;
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameUnionRequest);
			
			}else if(action.type == ConstantParameters.UNION_STATUS_ANSWER)
			{
				var gameUnionStatusAnswer:GameActionUnionStatusAnswer = new GameActionUnionStatusAnswer();
				gameUnionStatusAnswer.type = ConstantParameters.UNION_STATUS_ANSWER;
				gameUnionStatusAnswer.id   = LogicData.Get().actionCounter;
				
				gameUnionStatusAnswer.sourceCivilizationId = action.targetCivilizationId;
				gameUnionStatusAnswer.targetCivilizationId = action.sourceCivilizationId;
				
				gameUnionStatusAnswer.union = action.union;
				gameUnionStatusAnswer.stepsLeft = 1;
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameUnionStatusAnswer);
			
			}else if(action.type == ConstantParameters.TRADING_STATUS_REQUEST)
			{
				var gameTradeStatusRequest:GameActionTradingRequest = new GameActionTradingRequest();
				gameTradeStatusRequest.type = ConstantParameters.TRADING_STATUS_REQUEST;
				gameTradeStatusRequest.id   = LogicData.Get().actionCounter;
				
				gameTradeStatusRequest.sourceCivilizationId = action.targetCivilizationId;
				gameTradeStatusRequest.targetCivilizationId = action.sourceCivilizationId;
				
				gameTradeStatusRequest.trading = action.trading;
				gameTradeStatusRequest.stepsLeft = 1;
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameTradeStatusRequest);
				
			}else if(action.type == ConstantParameters.TRADING_STATUS_ANSWER)
			{
				var gameTradeStatusAnswer:GameActionTradingAnswer = new GameActionTradingAnswer();
				gameTradeStatusAnswer.type = ConstantParameters.TRADING_STATUS_ANSWER;
				gameTradeStatusAnswer.id   = LogicData.Get().actionCounter;
				
				gameTradeStatusAnswer.sourceCivilizationId = action.targetCivilizationId;
				gameTradeStatusAnswer.targetCivilizationId = action.sourceCivilizationId;
				
				gameTradeStatusAnswer.trading = action.trading;
				gameTradeStatusAnswer.stepsLeft = 1;
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameTradeStatusAnswer);
			
			}else if(action.type == ConstantParameters.ARMY_MOVEMENT_REQUEST)
			{
				var gameArmyMovementRequest:GameActionArmyMovemenRequest = new GameActionArmyMovemenRequest();
				gameArmyMovementRequest.type = ConstantParameters.ARMY_MOVEMENT_REQUEST;
				gameArmyMovementRequest.id   = LogicData.Get().actionCounter;
				
				gameArmyMovementRequest.sourceCivilizationId = action.sourceCivilizationId;
				gameArmyMovementRequest.targetCivilizationId = action.targetCivilizationId;
				
				gameArmyMovementRequest.accepted = action.accepted;
				gameArmyMovementRequest.stepsLeft = 1;
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameArmyMovementRequest);
				
				
			}else if(action.type == ConstantParameters.ARMY_MOVEMENT_ANSWER)
			{
				var gameArmyMovementAnswer:GameActionArmyMovementAnswer = new GameActionArmyMovementAnswer();
				gameArmyMovementAnswer.type = ConstantParameters.ARMY_MOVEMENT_ANSWER;
				gameArmyMovementAnswer.id   = LogicData.Get().actionCounter;
				
				gameArmyMovementAnswer.sourceCivilizationId = action.targetCivilizationId;
				gameArmyMovementAnswer.targetCivilizationId = action.sourceCivilizationId;
				
				gameArmyMovementAnswer.accepted = action.trading;
				gameArmyMovementAnswer.stepsLeft = 1;
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameArmyMovementAnswer);
			}
			
			LogicData.Get().actionCounter++;
		}
		
		private function findCurrentCivilizationAccodingProvince(provinceId:int):StateOfCivilization
		{			
			for (var i:int = 0; i < LogicData.Get().civilizationList.length; i++) 
			{
				for (var j:int = 0; j < LogicData.Get().civilizationList[i].provinces.length; j++) 
				{
					if(LogicData.Get().civilizationList[i].provinces[j].id == provinceId)
						return LogicData.Get().civilizationList[i];
				}				
			}			
			
			return null;
		}
		
		/**
		 * Call all action from stack.
		 */		
		private function updateStackAction():void
		{		
			var j:int;	
			
			for (var i:int = 0; i < stackActions.length; i++) 
			{
				if(stackActions[i])
				{
					var currentCivilization:StateOfCivilization = LogicData.Get().civilizationList[LogicData.Get().selectedCivilization];
					var provincesList:Vector.<StateOfProvince>  = LogicData.Get().provincesList;
										
					if(stackActions[i].type == ConstantParameters.BUY_ARMY)
					{
						for (j = 0; j < currentCivilization.provinces.length; j++) 
						{								
							if(currentCivilization.provinces[j].id == stackActions[j].sourceRegionID)
							{
								currentCivilization.provinces[j].armyNumber += stackActions[j].amount;	
								currentCivilization.army.number += stackActions[j].amount;
								
								currentCivilization.money -= ConstantParameters.ARMY_PRICE*stackActions[j].amount;
								
								break;	
							}
						}		
						
					}else if(stackActions[i].type == ConstantParameters.MOVE_ARMY)
					{
						for (j = 0; j < provincesList.length; j++) 
						{
							if(provincesList[j].id == stackActions[i].sourceRegionId && provincesList[j].armyNumber >= stackActions[i].amount)
							{
								provincesList[j].armyNumber -= stackActions[i].amount;
							}
							else if(provincesList[j].id == stackActions[i].destinationRegionId)
							{								
								provincesList[j].armyNumber += stackActions[i].amount;
							}
						}
					
					}else if(stackActions[i].type == ConstantParameters.ATTACK)
					{			
						var attackCiv:StateOfCivilization  = findCurrentCivilizationAccodingProvince(stackActions[i].sourceRegionId);
						var defenceCiv:StateOfCivilization = findCurrentCivilizationAccodingProvince(stackActions[i].destinationRegionId);
						
						/*Территория остаётся под контролем обороняющейся армии. 
						Количество юнитов обороняющейся армии равняется delta.
						Количество юнитов нападающей армии обнуляется.*/
						if(!stackActions[i].win)
						{
							for (j = 0; j < attackCiv.provinces.length; j++) 
							{
								if(attackCiv.provinces[j].id == stackActions[i].sourceRegionID)
								{
									attackCiv.provinces[j].armyNumber = 0;
									break;
								}
							}
							
							for (j = 0; j < defenceCiv.provinces.length; j++) 
							{
								if(defenceCiv.provinces[j].id == stackActions[i].sourceRegionID)
								{
									defenceCiv.provinces[j].armyNumber = stackActions[i].amount;
									break;
								}
							}
							
						}
						/*Территория переходит под. контроль атакующей армии. 
						Количество юнитов атакующей армии равняется abs(delta).
						Количество юнитов защищающейся армии обнуляется.
						Все здания на захваченной территории уничтожаются.*/
						else
						{							
							for (j = 0; j < defenceCiv.provinces.length; j++) 
							{
								if(defenceCiv.provinces[j].id == stackActions[i].destinationRegionId)
								{
									defenceCiv.provinces[j].buildingList = new Array();
									attackCiv.provinces.push(defenceCiv.provinces[j]);
									
									if(defenceCiv.army.number < stackActions[i].amount)									
										defenceCiv.army.number = 0;
									else
										defenceCiv.army.number -= stackActions[i].amount;								
									
									defenceCiv.provinces.splice(j, 1);
									break;
								}
							}
						}					
						
					}else if(stackActions[i].type == ConstantParameters.BUILD)
					{
						currentCivilization.provinces[i].buildProcess.current++;
						
						for (j = 0; j < currentCivilization.provinces.length; j++) 
						{								
							if(currentCivilization.provinces[j].id == stackActions[j].destinationRegionId)
							{
								if(currentCivilization.provinces[i].buildProcess.current == currentCivilization.provinces[i].buildProcess.total)
								{
									/// bonus from template building
									if(stackActions[i].buildingId == ConstantParameters.TEMPLATE.id)
									{
										currentCivilization.army.attack  += 1;
										currentCivilization.army.defence += 1;
									}								
									
									currentCivilization.provinces[i].buildingList.push(stackActions[i].buildingId);
									currentCivilization.provinces[i].buildProcess.current = 0;
								}
							}
						}					
						
					}else if(stackActions[i].type == ConstantParameters.BUY_TECHNOLOGY)
					{
						if(stackActions[i].stepsLeft==1){
							currentCivilization.technologyTree.activeTechnologies.push(stackActions[i].technologyId);
							
							
						}
						
					}else if(stackActions[i].type == ConstantParameters.UNION_STATUS_REQUEST)
					{
						trace("a");						
						
					}else if(stackActions[i].type == ConstantParameters.UNION_STATUS_ANSWER)
					{
						if(stackActions[i].union)
						{
							currentCivilization.diplomacy.union.push(stackActions[i].sourceCivilizationId);							
						}
					}else if(stackActions[i].type == ConstantParameters.TRADING_STATUS_REQUEST){
						
					}else if(stackActions[i].type == ConstantParameters.TRADING_STATUS_ANSWER){
						
						if(stackActions[i].union)
						{
							currentCivilization.diplomacy.trade.push(stackActions[i].sourceCivilizationId);	
							currentCivilization.totalBonusFromDiplomacyTrade += 10;
						}
					}else if(stackActions[i].type == ConstantParameters.ARMY_MOVEMENT_REQUEST){
						
					}else if(stackActions[i].type == ConstantParameters.ARMY_MOVEMENT_ANSWER)
					{
						if(stackActions[i].accepted)
						{
							currentCivilization.diplomacy.permitPassage.push(stackActions[i].sourceCivilizationId);								
						}
					}
					
					
					
					stackActions[i].stepsLeft--;
					
					if(stackActions[i].stepsLeft==0)
					{
						stackActions[i] = null;							
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
					setAction(message.data);
					break;
				}
			}
		}
	}
}