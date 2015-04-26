package main.view.interfaces.game
{
	import main.view.interfaces.IViewObject;
	
	import starling.text.TextField;

	public interface IUIGameView extends IViewObject
	{
		function loadUi(onUiLoadComplete:Function):void;		
		
		function getCivilizationNameTxt():TextField;		
		function getCivilizationMoneyTxt():TextField;
	}
}