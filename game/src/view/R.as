package view
{
	import flash.system.ApplicationDomain;

	public class R
	{
		public function R()
		{
			
		}
		
		public static function getClass(className:String):Class
		{
			if( ApplicationDomain.currentDomain.hasDefinition(className) ) return ApplicationDomain.currentDomain.getDefinition(className) as Class;
			return null;
		}
	}
}