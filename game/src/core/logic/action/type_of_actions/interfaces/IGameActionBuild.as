package core.logic.action.type_of_actions.interfaces
{
	public interface IGameActionBuild extends IGameAction
	{
		function get destinationRegionId ():int;
		
		function get buildingId():int;
	}
}