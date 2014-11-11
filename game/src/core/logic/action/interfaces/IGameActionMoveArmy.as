package core.logic.action.interfaces 
{
	public interface IGameActionMoveArmy extends IGameAction
	{
		function get sourceRegionId():int;
		
		function get destinationRegionId():int;
		
		function get amount():uint;
	}
}