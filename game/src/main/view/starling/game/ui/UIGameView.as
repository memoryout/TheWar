package main.view.starling.game.ui
{
	import main.view.interfaces.game.IUIGameView;
	
	import starling.display.Sprite;
	
	public class UIGameView extends Sprite implements IUIGameView
	{
		public function UIGameView()
		{
			super();
		}
		
		public function initialize(onInitComplete:Function):void
		{
			if(onInitComplete != null) onInitComplete();
			onInitComplete = null;
		}
	}
}