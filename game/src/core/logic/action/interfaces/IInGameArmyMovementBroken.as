package core.logic.action.interfaces
{
	public interface IInGameArmyMovementBroken extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;	
	}
}