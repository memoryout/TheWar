package core.logic.action.interfaces 
{
	public interface IGameActionUnionAnswer extends IGameAction
	{
		function get targetCivilizationId():int;
		
		function get sourceCivilizationId():int;
		
		function get answer():Boolean;
	}
}