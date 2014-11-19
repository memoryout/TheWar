package core.logic.action.interfaces
{
	public interface IGameActionArmyMovementAnswer extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get accepted():Boolean;
	}
}