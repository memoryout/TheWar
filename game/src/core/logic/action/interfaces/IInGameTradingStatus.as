package core.logic.action.interfaces
{
	public interface IInGameTradingStatus extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get union():Boolean;
	}
}