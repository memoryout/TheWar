package core.logic.action.interfaces
{
	public interface IGameActionBuild extends IGameAction
	{
		function get destinationRegionId ():int;
		
		function get buildingId():int;
	}
}