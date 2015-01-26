package main.data
{
	
	import core.logic.data.TechnologieInfo;
	
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
			super(this);
//			setSharedModule( MODULE_NAME, this );
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
						
					case "technologies":
					{
						if(_type == "xml") 
							parseTechnologiesXMLData(_content);		
						
						break;
					}
				}
			}				
			
			sendMessage(ApplicationEvents.DATA_SAVED, null);
		}
		
		private function parseRegionsXMLData(str:String):void
		{
			var xml:XML = new XML(str);
			var mapPar:String;
			
			for(mapPar in xml.maps.*)
			{
				var par:String, provinces:XMLList, provincesList:XML, provinceItem:ProvinceInfo, map:MapInfo = new MapInfo();
							
				map.id   		= xml.maps.map[mapPar].@id;
				map.name 		= xml.maps.map[mapPar].@name;
				map.sourceLink 	= xml.maps.map[mapPar].@source_link;
				map.tileXNum 	= xml.maps.map[mapPar].@tile_x_num;
				map.tileYNum 	= xml.maps.map[mapPar].@tile_y_num;
				
				provinces = xml.maps.map[mapPar].province;
				
				for(par in provinces)
				{
					provincesList = provinces[par];
					
					provinceItem 					= new ProvinceInfo();
					
					provinceItem.id 				= Number( provincesList.@id );
					provinceItem.moneyGrowth 		= Number( provincesList.@money_growth );				
					
					provinceItem.neighboringRegions = provincesList.@neighboring_provinces.split(",");
					
					map.provinces.push(provinceItem);
				}
				
				DataContainer.Get().addMap(map);	
			}					
		}
		
		private function parseScenariosXMLData(str:String):void
		{			
			var xml:XML = new XML(str);
			var scenarioPar:String;
			
			for(scenarioPar in xml.scenarios.*)
			{
				var par:String, civilization:XMLList, civilizationList:XML, civilizationItem:CivilizationInfo, scenario:ScenarioInfo = new ScenarioInfo();
				
				scenario.id		= xml.scenarios.scenario[scenarioPar].@id;
				scenario.name	= xml.scenarios.scenario[scenarioPar].@name;
				scenario.mapId 	= xml.scenarios.scenario[scenarioPar].@nmap_id;
				
				civilization = xml.scenarios.scenario[scenarioPar].civilization;
				
				for(par in civilization)
				{
					civilizationList = civilization[par];
					
					civilizationItem 					= new CivilizationInfo();
					civilizationItem.id 				= Number( civilizationList.@id );
					civilizationItem.money 				= Number( civilizationList.@money );
					civilizationItem.population 		= Number( civilizationList.@population );	
					civilizationItem.flag				= String( civilizationList.@flag);		
					civilizationItem.name				= String( civilizationList.@name);	
					
					civilizationItem.province 			= civilizationList.@region.split(",");
					
					scenario.civilizations.push(civilizationItem);
				}
				
				DataContainer.Get().addScenario(scenario);
			}			
			
		}
		
		private function parseTechnologiesXMLData(str:String):void
		{			
			var xml:XML = new XML(str);
			var technologiePar:String;
			
			for(technologiePar in xml.technologies.*)
			{
				var par:String, technologiesList:XML, technologie:TechnologieInfo = new TechnologieInfo();
				
				technologie.id				= xml.technologies.technologie[technologiePar].@id;
				technologie.name			= xml.technologies.technologie[technologiePar].@name;
				technologie.steps			= xml.technologies.technologie[technologiePar].@steps;
				technologie.nextToExplore 	= xml.technologies.technologie[technologiePar].@next_to_explore;
				technologie.opportiunities  = xml.technologies.technologie[technologiePar].@opportunities;
				technologie.value			= xml.technologies.technologie[technologiePar].@value;			
				
				DataContainer.Get().addTechnologie(technologie);
			}			
			
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationEvents.CONFIG_LOADED
			];
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