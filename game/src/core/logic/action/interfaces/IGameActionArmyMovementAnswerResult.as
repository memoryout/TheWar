package core.logic.action.interfaces
{
	public interface IGameActionArmyMovementAnswerResult extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get accepted():Boolean;
	}
}