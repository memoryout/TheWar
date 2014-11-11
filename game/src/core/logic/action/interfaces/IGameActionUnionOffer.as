package core.logic.action.interfaces
{
	public class IGameActionUnionOffer
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get marketing():Boolean;
		
		function get freeArmyMovement():Boolean;
	}
}