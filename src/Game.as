package
{
	import starling.display.Sprite;
	import screens.Welcome;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var screenWelcome:Welcome;
		
		public function Game()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);	
		}	
		private function onAddedToStage (event:Event):void
		{
			trace ("Starling Frameworks initialized!");
			
			screenWelcome = new Welcome();
			this.addChild(screenWelcome);
			screenWelcome.initialized();
		}
	
	}
}