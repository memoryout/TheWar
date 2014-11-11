package core.logic.action.interfaces 
{
	public interface IGameActionUnionCancel extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
	}
}