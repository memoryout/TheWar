package core.logic.action.interfaces
{
	public interface IInGameTradingBroken extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
	}
}