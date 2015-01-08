package core.logic.action.type_of_actions.interfaces
{
	public interface IGameActionTradingAnswer extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get trading():Boolean;
	}
}