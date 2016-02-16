package
{
	import flash.display.Sprite;
	import starling.events.Event
	
	public class Game extends Sprite
	{
		public function Game()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);	
		}	
		private function onAddedToStage (event:Event):void
		{
			trace ("Starling Frameworks initialized!");
		}
	
	}
}