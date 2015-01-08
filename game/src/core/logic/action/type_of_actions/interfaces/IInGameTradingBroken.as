package core.logic.action.type_of_actions.interfaces
{
	public interface IInGameTradingBroken extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
	}
}