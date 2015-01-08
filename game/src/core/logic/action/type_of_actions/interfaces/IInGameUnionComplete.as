package core.logic.action.type_of_actions.interfaces 
{
	public interface IInGameUnionComplete extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
	}
}