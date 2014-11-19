package core.logic.action.interfaces
{
	public interface IGameActionArmyMovementStatus extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get accepted():Boolean;
	}
}