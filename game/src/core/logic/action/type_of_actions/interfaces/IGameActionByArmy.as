package core.logic.action.type_of_actions.interfaces 
{
	public interface IGameActionByArmy extends IGameAction
	{
		function get sourceRegionID():int;
		
		function get amount():uint;
	}
}