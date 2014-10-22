package main.data
{
	import core.data.Civilization;
	import core.data.DataContainer;
	import core.data.Region;
	
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
					case "regions":
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
			
			var par:String, regions:XMLList, regionsList:XML, regionItem:Region;
			
			regions = xml.regions;
			
			for(par in regions.*)
			{
				regionsList = regions.*[par];
				
				regionItem = new Region();
				regionItem.id 					= Number( regionsList.@id );
				regionItem.money 				= Number( regionsList.@money );
				regionItem.growthMoney 			= Number( regionsList.@growth_money );
				regionItem.population 			= Number( regionsList.population );
				regionItem.growthPopulation 	= Number( regionsList.@growth_population );
				regionItem.army 				= Number( regionsList.@army );
				regionItem.civilization 		= String( regionsList.@civilization );
				regionItem.buildings 			= String( regionsList.buildings );
				regionItem.defence 				= Number( regionsList.defence );
				regionItem.neighboringRegions 	= regionsList.@neighboring_regions.split(",");
				
				DataContainer.Get().addRegion(regionItem);
			}
		}
		
		private function parseScenariosXMLData(str:String):void
		{
			var xml:XML = new XML(str);
			
			var par:String, scenarios:XMLList, scenariosList:XML, scenarioItem:Civilization;
			
			scenarios = xml.scenarios.scenario;
			
			for(par in scenarios.*)
			{
				scenariosList = scenarios.*[par];
				
				scenarioItem = new Civilization();
				scenarioItem.id 				= Number( scenariosList.@id );
				scenarioItem.money 				= Number( scenariosList.@money );
				scenarioItem.population 		= Number( scenariosList.@population );	
				scenarioItem.flag				= String( scenariosList.@flag);					
				
				scenarioItem.regions 	= scenariosList.@regions.split(",");
				
				DataContainer.Get().addCivilization(scenarioItem);
			}
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