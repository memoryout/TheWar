package core.logic.action.interfaces
{
	public interface IGameActionArmyMovemenRequest  extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get accepted():Boolean;
	}
}