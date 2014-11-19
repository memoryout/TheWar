package core.logic.action.interfaces
{
	public interface IGameActionTradingAnswerResult extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get trading():Boolean;
	}
}