package core.logic.action.interfaces
{
	public interface IGameActionAskForUnionStatus extends IGameAction
	{		
		function get targetCivilizationId():int;
	
		function get sourceCivilizationId():int;
				
		function get union():Boolean;
	}
}