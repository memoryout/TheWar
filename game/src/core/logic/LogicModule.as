package core.logic
{
	import core.logic.action.diplomacy.movement.GameActionArmyMovementAnswer;
	import core.logic.action.diplomacy.movement.InGameArmyMovementBroken;
	import core.logic.action.GameActionAskForUnionStatus;
	import core.logic.action.GameActionAttack;
	import core.logic.action.GameActionBuild;
	import core.logic.action.GameActionBuyTechnology;
	import core.logic.action.GameActionByArmy;
	import core.logic.action.GameActionMoveArmy;
	import core.logic.action.diplomacy.trading.GameActionTradingAnswer;
	import core.logic.action.diplomacy.trading.InGameTradingStatus;
	import core.logic.action.diplomacy.union.InGameUnionComplete;
	import core.logic.action.diplomacy.union.GameActionUnionStatusBroken;
	import core.logic.action.diplomacy.union.GameActionUnionStatusAnswer;
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
					gameAction.amount 				= currentProvince.armyNumber + action.amount;				
				
				gameAction.sourceRegionID		= action.sourceRegionID;				
				gameAction.stepsLeft 			= 1; 
				
				gameAction.id = LogicData.Get().actionCounter;
				
				stackAction.push(gameAction);
				
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
																
				stackAction.push(gameActionMove);
				
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
				
				stackAction.push(gameActionAttack);
				
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
				
				stackAction.push(gameActionBuild);		
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionBuild);					
				
			}else if(action.type == ConstantParameters.BUY_TECHNOLOGY){
				
				var gameActionByTechnology:GameActionBuyTechnology 	= new GameActionBuyTechnology();
				gameActionByTechnology.type 						= ConstantParameters.BUY_TECHNOLOGY;
				gameActionByTechnology.technologyId 				= action.technologyId;
				gameActionByTechnology.stepsLeft					= 1; // need change				
				gameActionByTechnology.id 							= LogicData.Get().actionCounter;
				
				stackAction.push(gameActionByTechnology);			
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameActionByTechnology);
				
			}else if(action.type == ConstantParameters.UNION_STATUS)
			{
				var gameUnionStatus:GameActionAskForUnionStatus = new GameActionAskForUnionStatus();
				gameUnionStatus.type = ConstantParameters.UNION_STATUS;
				gameUnionStatus.id   = LogicData.Get().actionCounter;
				
				gameUnionStatus.sourceCivilizationId = action.targetCivilizationId;
				gameUnionStatus.targetCivilizationId = action.ourceCivilizationId;
				
				gameUnionStatus.union = action.union;
				gameActionBuild.stepsLeft = 1;
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameUnionStatus);
			
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
			
			}else if(action.type == ConstantParameters.TRADING_STATUS)
			{
				var gameTradeStatus:InGameTradingStatus = new InGameTradingStatus();
				gameTradeStatus.type = ConstantParameters.TRADING_STATUS;
				gameTradeStatus.id   = LogicData.Get().actionCounter;
				
				gameTradeStatus.sourceCivilizationId = action.targetCivilizationId;
				gameTradeStatus.targetCivilizationId = action.sourceCivilizationId;
				
//				gameTradeStatus.trading = action.trading;
				gameTradeStatus.stepsLeft = 1;
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameTradeStatus);
				
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
			
			}else if(action.type == ConstantParameters.ARMY_MOVEMENT_STATUS)
			{
				var gameArmyMovementStatus:InGameArmyMovementBroken = new InGameArmyMovementBroken();
				gameArmyMovementStatus.type = ConstantParameters.ARMY_MOVEMENT_STATUS;
				gameArmyMovementStatus.id   = LogicData.Get().actionCounter;
				
				gameArmyMovementStatus.sourceCivilizationId = action.targetCivilizationId;
				gameArmyMovementStatus.targetCivilizationId = action.sourceCivilizationId;
				
//				gameArmyMovementStatus.accepted = action.trading;
				gameArmyMovementStatus.stepsLeft = 1;
				
				sendMessage(ViewEvent.GET_ACTION_DATA, gameArmyMovementStatus);
				
				
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
			
			for (var i:int = 0; i < stackAction.length; i++) 
			{
				if(stackAction[i])
				{
					var currentCivilization:StateOfCivilization = LogicData.Get().civilizationList[LogicData.Get().selectedCivilization];
					var provincesList:Vector.<StateOfProvince>  = LogicData.Get().provincesList;
										
					if(stackAction[i].type == ConstantParameters.BUY_ARMY)
					{
						for (j = 0; j < currentCivilization.provinces.length; j++) 
						{								
							if(currentCivilization.provinces[j].id == stackAction[j].sourceRegionID)
							{
								currentCivilization.provinces[j].armyNumber += stackAction[j].amount;	
								currentCivilization.army.number += stackAction[j].amount;
								
								currentCivilization.money -= ConstantParameters.ARMY_PRICE*stackAction[j].amount;
								
								break;	
							}
						}		
						
					}else if(stackAction[i].type == ConstantParameters.MOVE_ARMY)
					{
						for (j = 0; j < provincesList.length; j++) 
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
					
					}else if(stackAction[i].type == ConstantParameters.ATTACK)
					{			
						var attackCiv:StateOfCivilization  = findCurrentCivilizationAccodingProvince(stackAction[i].sourceRegionId);
						var defenceCiv:StateOfCivilization = findCurrentCivilizationAccodingProvince(stackAction[i].destinationRegionId);
						
						/*Территория остаётся под контролем обороняющейся армии. 
						Количество юнитов обороняющейся армии равняется delta.
						Количество юнитов нападающей армии обнуляется.*/
						if(!stackAction[i].win)
						{
							for (j = 0; j < attackCiv.provinces.length; j++) 
							{
								if(attackCiv.provinces[j].id == stackAction[i].sourceRegionID)
								{
									attackCiv.provinces[j].armyNumber = 0;
									break;
								}
							}
							
							for (j = 0; j < defenceCiv.provinces.length; j++) 
							{
								if(defenceCiv.provinces[j].id == stackAction[i].sourceRegionID)
								{
									defenceCiv.provinces[j].armyNumber = stackAction[i].amount;
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
								if(defenceCiv.provinces[j].id == stackAction[i].destinationRegionId)
								{
									defenceCiv.provinces[j].buildingList = new Array();
									attackCiv.provinces.push(defenceCiv.provinces[j]);
									
									if(defenceCiv.army.number < stackAction[i].amount)									
										defenceCiv.army.number = 0;
									else
										defenceCiv.army.number -= stackAction[i].amount;								
									
									defenceCiv.provinces.splice(j, 1);
									break;
								}
							}
						}					
						
					}else if(stackAction[i].type == ConstantParameters.BUILD)
					{
						currentCivilization.provinces[i].buildProcess.current++;
						
						for (j = 0; j < currentCivilization.provinces.length; j++) 
						{								
							if(currentCivilization.provinces[j].id == stackAction[j].destinationRegionId)
							{
								if(currentCivilization.provinces[i].buildProcess.current == currentCivilization.provinces[i].buildProcess.total)
								{
									/// bonus from template building
									if(stackAction[i].buildingId == ConstantParameters.TEMPLATE.id)
									{
										currentCivilization.army.attack  += 1;
										currentCivilization.army.defence += 1;
									}								
									
									currentCivilization.provinces[i].buildingList.push(stackAction[i].buildingId);
									currentCivilization.provinces[i].buildProcess.current = 0;
								}
							}
						}					
						
					}else if(stackAction[i].type == ConstantParameters.BUY_TECHNOLOGY)
					{
						
					}else if(stackAction[i].type == ConstantParameters.UNION_STATUS)
					{
						trace("a");						
						
					}else if(stackAction[i].type == ConstantParameters.UNION_STATUS_ANSWER)
					{
						if(stackAction[i].union)
						{
							currentCivilization.diplomacy.union.push(stackAction[i].sourceCivilizationId);							
						}
					}else if(stackAction[i].type == ConstantParameters.TRADING_STATUS){
						
					}else if(stackAction[i].type == ConstantParameters.TRADING_STATUS_ANSWER){
						
						if(stackAction[i].union)
						{
							currentCivilization.diplomacy.trade.push(stackAction[i].sourceCivilizationId);	
							currentCivilization.totalBonusFromDiplomacyTrade += 10;
						}
					}else if(stackAction[i].type == ConstantParameters.ARMY_MOVEMENT_STATUS){
						
					}else if(stackAction[i].type == ConstantParameters.ARMY_MOVEMENT_ANSWER)
					{
						if(stackAction[i].accepted)
						{
							currentCivilization.diplomacy.permitPassage.push(stackAction[i].sourceCivilizationId);								
						}
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