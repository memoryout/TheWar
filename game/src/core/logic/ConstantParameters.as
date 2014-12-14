package core.logic
{
	public class ConstantParameters
	{
		public static var ARMY_PRICE		:Number = 1;
		
		public static var TEMPLATE_BONUS	:Number = 2;
		
		public static var TEMPLATE:	Object = {"id":0, "totalStep":5};		
		public static var ACADEMY:	Object = {"id":1, "totalStep":5};		
		public static var WORKSHOP:	Object = {"id":2, "totalStep":5};		
		public static var FORT:		Object = {"id":3, "totalStep":5};		
		public static var PORT:		Object = {"id":4, "totalStep":5};		
		
		public static var BUILDINGS:Array = 
		[
			TEMPLATE,
			ACADEMY,
			WORKSHOP,
			FORT,
			PORT
		];
		
		public static var ATTACK:				String = "ATTACK";
		public static var BUY_ARMY: 			String = "BUY_ARMY";
		public static var MOVE_ARMY:			String = "MOVE_ARMY";
	
		public static var BUILD: 				String = "BUILD";
		public static var BUY_TECHNOLOGY: 		String = "BUY_TECHNOLOGY";
		
		public static var UNION_STATUS_REQUEST:		String = "UNION_STATUS_REQUEST";
		public static var UNION_STATUS_ANSWER: 		String = "UNION_STATUS_ANSWER";
		
		public static var TRADING_STATUS_REQUEST:	String = "TRADING_STATUS_REQUEST";
		public static var TRADING_STATUS_ANSWER:	String = "TRADING_STATUS_ANSWER";
		
		public static var ARMY_MOVEMENT_REQUEST:	String = "ARMY_MOVEMENT_REQUEST";
		public static var ARMY_MOVEMENT_ANSWER:		String = "ARMY_MOVEMENT_ANSWER";
		
		//// after step complete
		public static var BATTLE:					String = "BATTLE";
		public static var PROVINCE_CONQUIRED:		String = "PROVINCE_CONQUIRED";
		public static var PROVINCE_LOST:			String = "PROVINCE_LOST";
		public static var CIVILIZATION_DESTROYED:	String = "CIVILIZATION_DESTROYED";
		public static var BUILD_COMPLETE:			String = "BUILD_COMPLETE";
		public static var TECHNOLOGY_COMPLETE:		String = "TECHNOLOGY_COMPLETE";
		
		
		//////type of opportiunuties from technology
		
		public static var ATTACK_ARMY:				String = "attack_army";
		public static var DEFENCE_ARMY:				String = "defence_army";
		public static var PROVINCE_GROWTH:			String = "province_growth";
		
	}
}