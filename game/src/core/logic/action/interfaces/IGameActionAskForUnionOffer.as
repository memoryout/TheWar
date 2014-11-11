package core.logic.action.interfaces 
{
	public interface IGameActionAskForUnionOffer extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get marketing():Boolean;
		
		function get freeArmyMovement():Boolean;
	}
}