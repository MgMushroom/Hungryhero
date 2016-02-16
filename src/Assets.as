package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	
	public class Assets
	{
		
		[Embed(source="../Media/Graphics/bgWelcome.jpg")]
		public static const BgWelcome:Class;
		
		[Embed(source="../Media/Graphics/welcome_hero.png")]
		public static const WelcomeHero:Class;
		
		[Embed(source="../Media/Graphics/welcome_title.png")]
		public static const WelcomeTitle:Class;
		
		[Embed(source="../Media/Graphics/welcome_playButton.png")]
		public static const WelcomePlayBtn:Class;
		
		[Embed(source="../Media/Graphics/welcome_aboutButton.png")]
		public static const WelcomeAboutBtn:Class;
		
		
		private static var gameTextures:Dictionary = new Dictionary();
		
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