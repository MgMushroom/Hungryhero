package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		
		[Embed(source="../Media/Graphics/bgWelcome.jpg")]
		public static const BgWelcome:Class;
		
		/*[Embed(source="../Media/Graphics/welcome_hero.png")]
		public static const WelcomeHero:Class;
		
		[Embed(source="../Media/Graphics/welcome_title.png")]
		public static const WelcomeTitle:Class;
		
		[Embed(source="../Media/Graphics/welcome_playButton.png")]
		public static const WelcomePlayBtn:Class;
		
		[Embed(source="../Media/Graphics/welcome_aboutButton.png")]
		public static const WelcomeAboutBtn:Class;*/
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source="../Media/Graphics/mySpritesheet.png")]
		public static const AtlasTextureGame:Class; 
		
		[Embed(source="../Media/Graphics/mySpritesheet.xml", mimeType = "application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML( new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
		public static function getTexture(name:String):Texture
		{
			if(gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]()
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}