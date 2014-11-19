package core.logic.action.interfaces
{
	public interface IGameActionTradingRequest extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get trading():Boolean;
	}
}