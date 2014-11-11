package core.logic.action
{
	import core.logic.action.interfaces.IGameActionAskForUnionOffer;

	public class GameActionUnionOffer extends GameAction implements IGameActionAskForUnionOffer
	{			
		private var _targetCivilizationId:	int;
		private var _sourceCivilizationId:	int;
		
		private var _marketing:				Boolean;
		private var freeArmyMovement:		Boolean;
		
		public function get targetCivilizationId():int
		{
			return 	_targetCivilizationId;
		}
				
		public function set targetCivilizationId(val:int):void
		{
			_targetCivilizationId = val;	
		}
		
		public function get sourceCivilizationId():int
		{
			return 	_sourceCivilizationId;
		}
		
		public function set sourceCivilizationId(val:int):void
		{
			_sourceCivilizationId = val;	
		}
		
		public function get marketing():Boolean
		{
			return 	_marketing;
		}
		
		public function set marketing(val:Boolean):void
		{
			_marketing = val;	
		}
		
		public function get freeArmyMovement():Boolean
		{
			return 	freeArmyMovement;
		}
		
		public function set freeArmyMovement(val:Boolean):void
		{
			freeArmyMovement = val;	
		}
	}
}