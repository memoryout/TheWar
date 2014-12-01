package core.logic.action.interfaces 
{
	public interface IInGameUnionComplete extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
	}
}