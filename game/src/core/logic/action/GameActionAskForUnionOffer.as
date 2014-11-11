package core.logic.action
{
	import core.logic.action.interfaces.IGameActionUnionAnswer;

	public class GameActionAskForUnionOffer extends GameAction implements IGameActionUnionAnswer
	{
		private var _targetCivilizationId:	int;
		private var _sourceCivilizationId:	int;
		private var _marketing:				Boolean;
		private var _freeArmyMovement:		Boolean;
		
		public function GameActionAskForUnionOffer()
		{
		}
		
		public function get targetCivilizationId():int
		{
			return targetCivilizationId;
		}
		
		public function set targetCivilizationId(val:int):void
		{
			targetCivilizationId = val;
		}		
		
		public function get sourceCivilizationId():int
		{
			return _sourceCivilizationId;
		}
		
		public function set sourceCivilizationId(val:int):void
		{
			_sourceCivilizationId = val;
		}
				
		public function get marketing():Boolean
		{
			return _marketing;
		}
		
		public function set marketing(val:Boolean):void
		{
			_marketing = val;
		}
				
		public function get freeArmyMovement():Boolean
		{
			return _freeArmyMovement;
		}
		
		public function set freeArmyMovement(val:Boolean):void
		{
			_freeArmyMovement = val;
		}
	}
}