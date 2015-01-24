package main.view.starling
{
	import flash.utils.Dictionary;
	
	import main.view.application.asset.AtlasAsset;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class sResourceAsset
	{
		private static var _atlasList:			Dictionary = new Dictionary();
		private static var _textureList:		Dictionary = new Dictionary();
		
		public static function loadAtlassFromAsset(atlasAsset:AtlasAsset):void
		{
			var texture:Texture = Texture.fromBitmapData(atlasAsset.bitmapData);
			_textureList[atlasAsset.name] = texture;
			
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, atlasAsset.xml);
			_atlasList[atlasAsset.name] = textureAtlas;
		}
		
		public static function setAtlas(name:String, atlas:TextureAtlas):void
		{
			_atlasList[name] = atlas;
		}
		
		public static function getAtlas(name:String):TextureAtlas 
		{
			return _atlasList[name];
		}
		
		public static function unloadAll():void
		{
			var par:String;
			for(par in _atlasList)
			{
				_atlasList[par].dispose();
				delete _atlasList[par];
			}
			
			for(par in _textureList)
			{
				_textureList[par].dispose();
				delete _textureList[par];
			}
		}
	}
}