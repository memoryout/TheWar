package core.logic.action
{
	import core.logic.ConstantParameters;
	import core.logic.LogicData;
	import core.logic.action.type_of_actions.GameActionAttack;
	import core.logic.action.type_of_actions.GameActionBuild;
	import core.logic.action.type_of_actions.GameActionBuyTechnology;
	import core.logic.action.type_of_actions.GameActionByArmy;
	import core.logic.action.type_of_actions.GameActionMoveArmy;
	import core.logic.action.type_of_actions.diplomacy.movement.GameActionArmyMovemenRequest;
	import core.logic.action.type_of_actions.diplomacy.movement.GameActionArmyMovementAnswer;
	import core.logic.action.type_of_actions.diplomacy.trading.GameActionTradingAnswer;
	import core.logic.action.type_of_actions.diplomacy.trading.GameActionTradingRequest;
	import core.logic.action.type_of_actions.diplomacy.union.GameActionUnionStatusAnswer;
	import core.logic.action.type_of_actions.diplomacy.union.GameActionUnionStatusRequest;
	import core.logic.data.StateOfCivilization;
	import core.logic.data.StateOfProvince;
	import core.logic.data.TechnologieInfo;
	
	import main.data.DataContainer;
	import main.view.ViewEvent;
	
	public class ActionsCreator
	{
		private var sendMessage:Function;
		
		public function ActionsCreator(_sendMessage:Function)
		{
			sendMessage = _sendMessage;
		}
		
		public function create(action:Object):void
		{				
			switch(action.type)
			{
				case ConstantParameters.BUY_ARMY:				
					actionByArmy(action);
					break;				
				
				case ConstantParameters.MOVE_ARMY:				
					actionMoveArmy(action);
					break;				
				
				case ConstantParameters.ATTACK:				
					actionAttack(action);
					break;		
				
				case ConstantParameters.BUILD:				
					actionBuild(action);
					break;			
				
				case ConstantParameters.BUY_TECHNOLOGY:				
					actionBuyTechnology(action);
					break;		
				
				case ConstantParameters.UNION_STATUS_REQUEST:				
					actionUnionStatusRequest(action);
					break;		
				
				case ConstantParameters.UNION_STATUS_ANSWER:				
					actionUnionStatusAnswer(action);
					break;		
				
				case ConstantParameters.TRADING_STATUS_REQUEST:				
					actionTradingStatusRequest(action);
					break;		
				
				case ConstantParameters.TRADING_STATUS_ANSWER:				
					actionTradingStatusAnswer(action);
					break;	
				
				case ConstantParameters.ARMY_MOVEMENT_REQUEST:				
					actionArmyMovementRequest(action);
					break;	
				
				case ConstantParameters.ARMY_MOVEMENT_ANSWER:				
					actionArmyMovementAnswer(action);
					break;
			}
			
			LogicData.Get().actionCounter++;
		}
		
		private function actionByArmy(actionData:Object):void
		{
			var currentCivilization:StateOfCivilization = LogicData.Get().civilizationList[LogicData.Get().selectedCivilization],
				currentProvince:StateOfProvince = getProvinceWithId(actionData.sourceRegionID);			
			
			var gameAction:GameActionByArmy = new GameActionByArmy();
			
			gameAction.type 				= ConstantParameters.BUY_ARMY;
			gameAction.sourceRegionID		= actionData.sourceRegionID;				
			gameAction.stepsLeft 			= 1; 			
			gameAction.id 					= LogicData.Get().actionCounter;
			
			if(ConstantParameters.ARMY_PRICE*actionData.amount <= currentCivilization.money)				
				gameAction.amount = currentProvince.armyNumber + actionData.amount;					
			
			LogicData.Get().stackActions.push(gameAction);
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameAction);
		}
		
		private function actionMoveArmy(actionData:Object):void
		{
			var gameActionMove:GameActionMoveArmy 	= new GameActionMoveArmy(),
			provincesList:Vector.<StateOfProvince>  = LogicData.Get().provincesList;
			
			gameActionMove.type 		= ConstantParameters.MOVE_ARMY;
			gameActionMove.amount 		= actionData.amount;		
			gameActionMove.stepsLeft 	= 1; 									// need change ?				
			gameActionMove.id 			= LogicData.Get().actionCounter;
			
			for (var i:int = 0; i < provincesList.length; i++) 
			{
				if(provincesList[i].id == actionData.sourceRegionID)					
					gameActionMove.sourceRegionId 		= actionData.sourceRegionID;							
									
				else if(provincesList[i].id == actionData.destinationRegionId)					
					gameActionMove.destinationRegionId  = actionData.destinationRegionId;							
			}
			
			LogicData.Get().stackActions.push(gameActionMove);
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameActionMove);
		}
		
		private function actionAttack(actionData:Object):void
		{
			var attackProvince:StateOfProvince, defenceProvince:StateOfProvince,
				
			gameActionAttack:GameActionAttack = new GameActionAttack();
			
			gameActionAttack.type 					= ConstantParameters.ATTACK;
			gameActionAttack.stepsLeft 				= 1; 									// need change ?				
			gameActionAttack.id 					= LogicData.Get().actionCounter;
			gameActionAttack.sourceRegionId 		= actionData.sourceRegionID;
			gameActionAttack.destinationRegionId  	= actionData.destinationRegionId;		
					
			var delta:Number = defineWhoWinBattle(actionData);
			
			if(delta >= 0)
				gameActionAttack.win = false;
			else if(delta < 0)						
				gameActionAttack.win = true;
			
			gameActionAttack.amount = Math.abs(delta);						
				
			LogicData.Get().stackActions.push(gameActionAttack);
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameActionAttack);
		}
		
		private function actionBuild(actionData:Object):void
		{
			var currentProvince:StateOfProvince = getProvinceWithId(actionData.destinationRegionId);
			var gameActionBuild:GameActionBuild = new GameActionBuild();		
			
			currentProvince.buildProcess.total  = getTotalStepsToCreateBuilding(actionData.buildingId);						
			gameActionBuild.type 				= ConstantParameters.BUILD;
			gameActionBuild.stepsLeft 			= currentProvince.buildProcess.total;			
			gameActionBuild.buildingId 			= actionData.buildingId;
			gameActionBuild.destinationRegionId = actionData.destinationRegionId;					
			gameActionBuild.id 					= LogicData.Get().actionCounter;
			
			LogicData.Get().stackActions.push(gameActionBuild);		
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameActionBuild);					
		}
		
		private function actionBuyTechnology(actionData:Object):void
		{			
			var gameActionByTechnology:GameActionBuyTechnology 	= new GameActionBuyTechnology();
			
			gameActionByTechnology.type 			= ConstantParameters.BUY_TECHNOLOGY;
			gameActionByTechnology.technologyId 	= actionData.technologyId;			
			gameActionByTechnology.stepsLeft 		= getTotalStepsToCreateTechnology(actionData.technologyId);						
			gameActionByTechnology.id 				= LogicData.Get().actionCounter;
			
			LogicData.Get().stackActions.push(gameActionByTechnology);			
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameActionByTechnology);
		}
		
		private function actionUnionStatusRequest(actionData:Object):void
		{
			var gameUnionRequest:GameActionUnionStatusRequest = new GameActionUnionStatusRequest();
			
			gameUnionRequest.type 					= ConstantParameters.UNION_STATUS_REQUEST;
			gameUnionRequest.id   					= LogicData.Get().actionCounter;			
			gameUnionRequest.sourceCivilizationId 	= actionData.targetCivilizationId;
			gameUnionRequest.targetCivilizationId 	= actionData.ourceCivilizationId;			
			gameUnionRequest.union 				  	= actionData.union;
			gameUnionRequest.stepsLeft 			  	= 1;
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameUnionRequest);
		}
		
		private function actionUnionStatusAnswer(actionData:Object):void
		{
			var gameUnionStatusAnswer:GameActionUnionStatusAnswer = new GameActionUnionStatusAnswer();
			
			gameUnionStatusAnswer.type 					= ConstantParameters.UNION_STATUS_ANSWER;
			gameUnionStatusAnswer.id   					= LogicData.Get().actionCounter;			
			gameUnionStatusAnswer.sourceCivilizationId 	= actionData.targetCivilizationId;
			gameUnionStatusAnswer.targetCivilizationId 	= actionData.sourceCivilizationId;			
			gameUnionStatusAnswer.union 				= actionData.union;
			gameUnionStatusAnswer.stepsLeft 			= 1;
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameUnionStatusAnswer);
		}
		
		private function actionTradingStatusRequest(actionData:Object):void
		{
			var gameTradeStatusRequest:GameActionTradingRequest = new GameActionTradingRequest();
			
			gameTradeStatusRequest.type 				= ConstantParameters.TRADING_STATUS_REQUEST;
			gameTradeStatusRequest.id   				= LogicData.Get().actionCounter;			
			gameTradeStatusRequest.sourceCivilizationId = actionData.targetCivilizationId;
			gameTradeStatusRequest.targetCivilizationId = actionData.sourceCivilizationId;			
			gameTradeStatusRequest.trading 				= actionData.trading;
			gameTradeStatusRequest.stepsLeft 			= 1;
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameTradeStatusRequest);
		}
		
		private function actionTradingStatusAnswer(actionData:Object):void
		{
			var gameTradeStatusAnswer:GameActionTradingAnswer = new GameActionTradingAnswer();
			
			gameTradeStatusAnswer.type 					= ConstantParameters.TRADING_STATUS_ANSWER;
			gameTradeStatusAnswer.id   					= LogicData.Get().actionCounter;			
			gameTradeStatusAnswer.sourceCivilizationId 	= actionData.targetCivilizationId;
			gameTradeStatusAnswer.targetCivilizationId	= actionData.sourceCivilizationId;			
			gameTradeStatusAnswer.trading				= actionData.trading;
			gameTradeStatusAnswer.stepsLeft = 1;
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameTradeStatusAnswer);
		}
		
		private function actionArmyMovementRequest(actionData:Object):void
		{
			var gameArmyMovementRequest:GameActionArmyMovemenRequest = new GameActionArmyMovemenRequest();
			
			gameArmyMovementRequest.type 					= ConstantParameters.ARMY_MOVEMENT_REQUEST;
			gameArmyMovementRequest.id   					= LogicData.Get().actionCounter;			
			gameArmyMovementRequest.sourceCivilizationId 	= actionData.sourceCivilizationId;
			gameArmyMovementRequest.targetCivilizationId 	= actionData.targetCivilizationId;			
			gameArmyMovementRequest.accepted 				= actionData.accepted;
			gameArmyMovementRequest.stepsLeft 				= 1;
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameArmyMovementRequest);
		}
		
		private function actionArmyMovementAnswer(actionData:Object):void
		{
			var gameArmyMovementAnswer:GameActionArmyMovementAnswer = new GameActionArmyMovementAnswer();
		
			gameArmyMovementAnswer.type					= ConstantParameters.ARMY_MOVEMENT_ANSWER;
			gameArmyMovementAnswer.id   				= LogicData.Get().actionCounter;			
			gameArmyMovementAnswer.sourceCivilizationId = actionData.targetCivilizationId;
			gameArmyMovementAnswer.targetCivilizationId = actionData.sourceCivilizationId;			
			gameArmyMovementAnswer.accepted 			= actionData.trading;
			gameArmyMovementAnswer.stepsLeft 			= 1;
			
			sendMessage(ViewEvent.GET_ACTION_DATA, gameArmyMovementAnswer);
		}
		
		private function getProvinceWithId(idx:int):StateOfProvince
		{
			var currentCivilization:StateOfCivilization = LogicData.Get().civilizationList[LogicData.Get().selectedCivilization];
			
			for (var i:int = 0; i < currentCivilization.provinces.length; i++) 
			{								
				if(currentCivilization.provinces[i].id == idx)				
					return currentCivilization.provinces[i];				
			}
			
			return null;
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
		
		private function defineWhoWinBattle(actionData:Object):Number
		{
			var attackProvince:StateOfProvince, defenceProvince:StateOfProvince,
			
			civilizationThatAttacks:StateOfCivilization  = findCurrentCivilizationAccodingProvince(actionData.sourceRegionID),
			civilizationThatDefence:StateOfCivilization  = findCurrentCivilizationAccodingProvince(actionData.destinationRegionId),
			provincesList:Vector.<StateOfProvince> 		 = LogicData.Get().provincesList;
			
			for (var i:int = 0; i < provincesList.length; i++) 
			{
				if(provincesList[i].id == actionData.sourceRegionID)					
					attackProvince = provincesList[i];	
					
				else if(provincesList[i].id == actionData.destinationRegionId)									
					defenceProvince = provincesList[i];				
			}
			
			return civilizationThatDefence.army.defence*defenceProvince.armyNumber - civilizationThatAttacks.army.attack*attackProvince.armyNumber;
		}
		
		/**
		 * Find buiding Id and get total steps to creation building.
		 * @param currentProvince
		 * @param buildingId
		 * 
		 */		
		private function getTotalStepsToCreateBuilding(buildingId:int):int
		{
			for (var k:int = 0; k < ConstantParameters.BUILDINGS.length; k++) 
			{
				if(ConstantParameters.BUILDINGS[k].id == buildingId)				
					return ConstantParameters.BUILDINGS[k].totalStep;					
			}	
			
			return 0;
		}
		
		/**
		 * Find buiding Id and get total steps to creation building.
		 * @param currentProvince
		 * @param buildingId
		 * 
		 */		
		private function getTotalStepsToCreateTechnology(technologyId:int):int
		{
			for (var j:int = 0; j < DataContainer.Get().getTechnologiesList().length; j++) 
			{
				if(DataContainer.Get().getTechnologiesList()[j].id == technologyId)				
					return DataContainer.Get().getTechnologiesList()[j].steps;				
			}
			
			return 0;
		}
	}
}