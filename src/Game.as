package
{
	import events.NavigationEvent;
	
	import screens.InGame;
	import screens.Welcome;
	
	import starling.display.Sprite;
	import starling.events.Event;

	
	public class Game extends Sprite
	{
		private var screenInGame:InGame;
		private var screenWelcome:Welcome;
		
		
		public function Game()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);	
		}	
		private function onAddedToStage (event:Event):void
		{
			trace ("Starling Frameworks initialized!");
			
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			
			screenWelcome = new Welcome();
			this.addChild(screenWelcome);
			screenWelcome.initialized();
			
			screenInGame = new InGame;
			this.addChild(screenInGame);
			screenInGame.disposeTemporarily();
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "play":
					screenWelcome.disposeTemporarily();
					screenInGame.initialized();
					
					break;
			}
			
		}
		
	}
}