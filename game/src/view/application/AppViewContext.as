package view.application
{
	import main.broadcast.Module;
	
	public class AppViewContext extends Module
	{
		protected var parentContext:		AppViewContext;
		
		public function AppViewContext()
		{
			super();
		}
		
		public function setParentConext(parentContext:AppViewContext):void
		{
			parentContext = parentContext;
		}
		
		
	}
}