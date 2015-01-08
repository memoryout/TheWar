package core.logic.action.type_of_actions.interfaces
{
	public interface IGameActionRequestForUnionStatus extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int; 
		
		function get union():Boolean;
	}
}