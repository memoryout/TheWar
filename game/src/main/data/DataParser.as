package main.data
{
	
	import main.broadcast.Module;
	import main.broadcast.message.MessageData;
	import main.events.ApplicationEvents;

	public class DataParser  extends Module
	{
		public static const MODULE_NAME:		String = "DataParser";
		
		private var _content:			String;
		private var _type:				String;
		private var _table:				String;
		
		public function DataParser()
		{
			setSharedModule( MODULE_NAME, this );
		}
		
		private function readVariables(val:Object):void
		{
			for (var j:int = 0; j < val.length; j++) 
			{
				var vars:Array = val[j].split("@");
				
				vars.shift();
				
				var i:int, variable:String, symbol:String;
				for(i = 0; i < vars.length; i++)
				{
					variable = vars[i];
					symbol = variable.charAt( variable.length - 1 );
					while(symbol == "\n" || symbol == "\r")
					{
						variable = variable.slice(0, variable.length - 1);
						symbol = variable.charAt( variable.length - 1 );
					}
					
					vars[i] = variable;
				}			
				
				var values:Array;
				
				for(i = 0; i < vars.length; i++)
				{
					values = String(vars[i]).split("=");
					
					variable = values.shift();
					symbol = values.join("=");
					
					switch(variable)
					{
						case "type":
						{
							_type = symbol;
							break;
						}
							
						case "table":
						{
							_table = symbol;
							break;
						}
							
						case "content":
						{
							_content = symbol;
							break;
						}
					}
				}
				
				switch(_table)
				{
					case "maps":
					{
						if(_type == "xml") 
							parseRegionsXMLData(_content);		
						
						break;
					}
						
					case "scenarios":
					{
						if(_type == "xml") 
							parseScenariosXMLData(_content);		
						
						break;
					}
				}
			}				
			
			sendMessage(ApplicationEvents.DATA_SAVED, null);
		}
		
		private function parseRegionsXMLData(str:String):void
		{
			var xml:XML = new XML(str);
			
			var par:String, maps:XMLList, provincesList:XML, provinceItem:ProvinceInfo, map:MapInfo = new MapInfo();
						
			map.id   = xml.maps.map.@id;
			map.name = xml.maps.map.@name;			
			
			maps = xml.map;
			
			for(par in maps.*)
			{
				provincesList = maps.*[par];
				
				provinceItem 					= new ProvinceInfo();
				
				provinceItem.id 				= Number( provincesList.@id );
				provinceItem.moneyGrowth 		= Number( provincesList.@money_growth );				
				
				provinceItem.neighboringRegions = provincesList.@neighboring_regions.split(",");
				
				map.provinces.push(provinceItem);
			}
			
			DataContainer.Get().addMap(map);			
		}
		
		private function parseScenariosXMLData(str:String):void
		{
			var xml:XML = new XML(str);
			
			var par:String, civilization:XMLList, civilizationList:XML, civilizationItem:CivilizationInfo, scenario:ScenarioInfo = new ScenarioInfo();
			
			scenario.id		= xml.scenarios.scenario.@id;
			scenario.name	= xml.scenarios.scenario.@name;
			
			civilization = xml.scenarios.scenario;
			
			for(par in civilization.*)
			{
				civilizationList = civilization.*[par];
				
				civilizationItem 					= new CivilizationInfo();
				civilizationItem.id 				= Number( civilizationList.@id );
				civilizationItem.money 				= Number( civilizationList.@money );
				civilizationItem.population 		= Number( civilizationList.@population );	
				civilizationItem.flag				= String( civilizationList.@flag);		
				civilizationItem.name				= String( civilizationList.@name);	
				
				civilizationItem.region 			= civilizationList.@region.split(",");
				
				scenario.civilizations.push(civilizationItem);
			}
			
			DataContainer.Get().addScenario(scenario);
		}
		
		override public function receiveMessage(message:MessageData):void
		{		
			switch(message.message)
			{
				case ApplicationEvents.CONFIG_LOADED:
				{
					readVariables(message.data);
					break;
				}	
			}
		}
	}
}