package core.logic.action.interfaces 
{
	public interface IGameActionByArmy extends IGameAction
	{
		function get sourceRegionID():int;
		
		function get amount():uint;
	}
}