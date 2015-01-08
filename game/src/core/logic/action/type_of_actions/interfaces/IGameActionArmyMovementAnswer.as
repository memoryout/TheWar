package core.logic.action.type_of_actions.interfaces
{
	public interface IGameActionArmyMovementAnswer extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get accepted():Boolean;
	}
}