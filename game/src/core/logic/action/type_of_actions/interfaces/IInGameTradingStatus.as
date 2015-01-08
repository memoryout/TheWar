package core.logic.action.type_of_actions.interfaces
{
	public interface IInGameTradingStatus extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get union():Boolean;
	}
}