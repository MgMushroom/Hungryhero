package screens
{
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Welcome extends Sprite
	{
		private var bg:Image;
		private var title:Image;
		private var hero:Image;
		
		private var playBtn:Button;
		private var aboutBtn:Button;
		
		public function Welcome()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Welcome screen initialized!");
			drawScreen();
		}
		
		private function drawScreen():void
		{
			bg = new Image (Assets.getTexture("BgWelcome"));
			this.addChild(bg);
			
			title = new Image (Assets.getTexture("WelcomeTitle"));
			title.x = 440;
			title.y = 20;
			this.addChild(title);
			
			
			hero = new Image (Assets.getTexture("WelcomeHero"));
			this.addChild(hero);
			
			playBtn = new Button (Assets.getTexture("WelcomePlayBtn"));
			playBtn.x = 500;
			playBtn.y = 260;
			this.addChild(playBtn);
			
			aboutBtn = new Button (Assets.getTexture("WelcomeAboutBtn"));
			aboutBtn.x = 410;
			aboutBtn.y = 380;
			this.addChild(aboutBtn);
		}
	}
}