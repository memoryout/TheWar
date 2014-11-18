package core.logic.action.interfaces
{
	public interface IGameActionAttack extends IGameAction
	{
		function get sourceRegionId():int;
		
		function get destinationRegionId():int;
		
		function get amount():Number;
	}
}