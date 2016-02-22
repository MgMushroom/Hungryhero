package screens
{
	import objects.GameBackground;
	import objects.Hero;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class InGame extends Sprite
	{	
		private var bg:GameBackground;
		private var hero:Hero;
		
		public function InGame()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);	
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);	
			drawHero();
		}
		
		private function drawHero():void
		{	
			bg = new GameBackground();
			bg.speed = 10;
			this.addChild(bg);
			
			hero = new Hero();
			hero.x = stage.stageWidth/2;
			hero.y = stage.stageWidth/2;
			this.addChild(hero);
		}	
	
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialized():void
		{
			this.visible = true;
		}
	
	}
}