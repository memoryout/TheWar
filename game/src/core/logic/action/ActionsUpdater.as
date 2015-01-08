package core.logic.action
{
	import core.logic.ConstantParameters;
	import core.logic.LogicData;
	import core.logic.data.StateOfCivilization;
	import core.logic.data.StateOfProvince;
	import core.logic.data.TechnologieInfo;
	
	import main.data.DataContainer;

	public class ActionsUpdater
	{
		private var currentCivilization:StateOfCivilization;
		private var provincesList:Vector.<StateOfProvince>;
		
		public function ActionsUpdater()
		{
		}
		
		/**
		 * Call all action from stack.
		 */		
		public function update():void
		{		
			var stackActions:Array 	= LogicData.Get().stackActions;
			currentCivilization 	= LogicData.Get().civilizationList[LogicData.Get().selectedCivilization];
			provincesList  			= LogicData.Get().provincesList;
			
			for (var i:int = 0; i < stackActions.length; i++) 
			{
				if(stackActions[i])
				{				
					switch(stackActions[i].type)
					{
						case ConstantParameters.BUY_ARMY:				
							actionByArmy(stackActions[i]);
							break;				
						
						case ConstantParameters.MOVE_ARMY:				
							actionMoveArmy(stackActions[i]);
							break;				
						
						case ConstantParameters.ATTACK:				
							actionAttack(stackActions[i]);
							break;		
						
						case ConstantParameters.BUILD:				
							actionBuild(stackActions[i]);
							break;			
						
						case ConstantParameters.BUY_TECHNOLOGY:				
							actionBuyTechnology(stackActions[i]);
							break;		
						
						case ConstantParameters.UNION_STATUS_REQUEST:				
							actionUnionStatusRequest(stackActions[i]);
							break;		
						
						case ConstantParameters.UNION_STATUS_ANSWER:				
							actionUnionStatusAnswer(stackActions[i]);
							break;		
						
						case ConstantParameters.TRADING_STATUS_REQUEST:				
							actionTradingStatusRequest(stackActions[i]);
							break;		
						
						case ConstantParameters.TRADING_STATUS_ANSWER:				
							actionTradingStatusAnswer(stackActions[i]);
							break;	
						
						case ConstantParameters.ARMY_MOVEMENT_REQUEST:				
							actionArmyMovementRequest(stackActions[i]);
							break;	
						
						case ConstantParameters.ARMY_MOVEMENT_ANSWER:				
							actionArmyMovementAnswer(stackActions[i]);
							break;
					}				
					
					stackActions[i].stepsLeft--;
					
					if(stackActions[i].stepsLeft == 0)					
						stackActions[i] = null;			
				}				
			}			
		}
		
		private function actionByArmy(action:Object):void
		{
			for (var j:int = 0; j < currentCivilization.provinces.length; j++) 
			{								
				if(currentCivilization.provinces[j].id == action.sourceRegionID)
				{
					currentCivilization.provinces[j].armyNumber += action.amount;	
					currentCivilization.army.number 			+= action.amount;
					
					currentCivilization.money 					-= ConstantParameters.ARMY_PRICE*action.amount;
					
					break;	
				}
			}		
		}
		
		private function actionMoveArmy(action:Object):void
		{			
			for (var j:int = 0; j < provincesList.length; j++) 
			{
				if(provincesList[j].id == action.sourceRegionId && provincesList[j].armyNumber >= action.amount)
					provincesList[j].armyNumber -= action.amount;
				
				else if(provincesList[j].id == action.destinationRegionId)												
					provincesList[j].armyNumber += action.amount;				
			}
		}
		
		private function actionAttack(action:Object):void
		{
			var attackCiv:StateOfCivilization  = findCurrentCivilizationAccodingProvince(action.sourceRegionId);
			var defenceCiv:StateOfCivilization = findCurrentCivilizationAccodingProvince(action.destinationRegionId);
			var j:int;
			
			/*Территория остаётся под контролем обороняющейся армии. 
			Количество юнитов обороняющейся армии равняется delta.
			Количество юнитов нападающей армии обнуляется.*/
			if(!action.win)
			{
				for (j = 0; j < attackCiv.provinces.length; j++) 
				{
					if(attackCiv.provinces[j].id == action.sourceRegionID)
					{
						attackCiv.provinces[j].armyNumber = 0;
						break;
					}
				}
				
				for (j = 0; j < defenceCiv.provinces.length; j++) 
				{
					if(defenceCiv.provinces[j].id == action.sourceRegionID)
					{
						defenceCiv.provinces[j].armyNumber = action.amount;
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
					if(defenceCiv.provinces[j].id == action.destinationRegionId)
					{
						defenceCiv.provinces[j].buildingList = new Array();
						attackCiv.provinces.push(defenceCiv.provinces[j]);
						
						if(defenceCiv.army.number < action.amount)									
							defenceCiv.army.number = 0;
						else
							defenceCiv.army.number -= action.amount;								
						
						defenceCiv.provinces.splice(j, 1);
						break;
					}
				}
			}					
		}
		
		private function actionBuild(action:Object):void
		{
			for (var j:int = 0; j < currentCivilization.provinces.length; j++) 
			{				
				if(currentCivilization.provinces[j].id == action.destinationRegionId)
				{
					currentCivilization.provinces[j].buildProcess.current++;					
					
					if(currentCivilization.provinces[j].buildProcess.current == currentCivilization.provinces[j].buildProcess.total)
					{
						/// bonus from template building
						if(action.buildingId == ConstantParameters.TEMPLATE.id)
						{
							currentCivilization.army.attack  += 1;
							currentCivilization.army.defence += 1;
						}								
						
						currentCivilization.provinces[j].buildingList.push(action.buildingId);
						currentCivilization.provinces[j].buildProcess.current = 0;
					}
				}
			}					
		}
		
		private function actionBuyTechnology(action:Object):void
		{	
			if(action.stepsLeft == 1){
				
				currentCivilization.technologyTree.activeTechnologies.push(action.technologyId);
				
				for (var k:int = 0; k < DataContainer.Get().getTechnologiesList().length; k++) 
				{
					if(DataContainer.Get().getTechnologiesList()[k].id == action.id)
					{
						var element:TechnologieInfo = DataContainer.Get().getTechnologiesList()[k];
						var value:Array = element.value.split(" ");
						
						switch(element.opportiunities)
						{
							case ConstantParameters.ATTACK_ARMY:
							{
								if(value[0] == "+")
									currentCivilization.army.attack += value[1];
								else
									currentCivilization.army.attack -= value[1];
								
								break;
							}
							case ConstantParameters.DEFENCE_ARMY:
							{
								if(value[0] == "+")
									currentCivilization.army.defence += value[1];
								else
									currentCivilization.army.defence -= value[1];
								
								break;
							}
						}
						
						break;
					}
				}							
			}
		}
		
		private function actionUnionStatusRequest(action:Object):void
		{
			
		}
		
		private function actionUnionStatusAnswer(action:Object):void
		{
			if(action.union)			
				currentCivilization.diplomacy.union.push(action.sourceCivilizationId);						
		}
		
		private function actionTradingStatusRequest(action:Object):void
		{
			
		}
		
		private function actionTradingStatusAnswer(action:Object):void
		{
			if(action.union)
			{
				currentCivilization.diplomacy.trade.push(action.sourceCivilizationId);	
				currentCivilization.totalBonusFromDiplomacyTrade += 10;
			}
		}
		
		private function actionArmyMovementRequest(action:Object):void
		{
		}
		
		private function actionArmyMovementAnswer(action:Object):void
		{			
			if(action.accepted)			
				currentCivilization.diplomacy.permitPassage.push(action.sourceCivilizationId);								
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
	}
}