package core.logic.action.type_of_actions.interfaces
{
	public interface IGameActionAttack extends IGameAction
	{
		function get sourceRegionId():int;
		
		function get destinationRegionId():int;
		
		function get amount():Number;
	}
}