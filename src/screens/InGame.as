package screens
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import objects.GameBackground;
	import objects.Hero;
	import objects.Item;
	import objects.Obstacles;
	import objects.Particles;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	
	
	
	public class InGame extends Sprite
	{	
		private var startButton:Button;
		private var bg:GameBackground;
		private var hero:Hero;
		
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		
		private var gameState:String;
		private var playerSpeed:Number;
		private var hitObstacle:Number = 0;
		private const MIN_SPEED:Number = 650;
		
		private var obstacleGapCount:int;
		
		private var gameArea:Rectangle;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		private var obstaclesToAnimate:Vector.<Obstacles>; 
		private var itemsToAnimate:Vector.<Item>;
		private var eatParticlesToAnimate:Vector.<Particles>;
		
		private var feetDistanceText:TextField;
		private var scoreItem:TextField;
		private var scoreTotal:TextField;
		private var border:TextField;
		private var total:int;
		private var score:int;
		private var scoreDistance:int;
		
		public function InGame()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);	
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);	
			drawHero();
			drawScore();
			
		
		}
		
		private function drawScore():void
		{
			border = new TextField(800, 80, "", "MyFontName", 24, 0xffffff);
			border.border = true;
			//this.addChild(border);
			
			feetDistanceText = new TextField(300,100,"Distance: 0 ft", "MyFontName", 24, 0xffffff); 
			feetDistanceText.x += 100;
			this.addChild(feetDistanceText);
			
			scoreItem = new TextField(300,100,"Food: 0 ", "MyFontName", 24,0xffffff);
			scoreItem.x += 250;
			this.addChild(scoreItem);
			
			scoreTotal = new TextField(300,100,"TotalScore: 0 ","MyFontName", 24,0xffffff);
			scoreTotal.x += 400;
			this.addChild(scoreTotal);
			
		}
		
		private function drawHero():void
		{	
			bg = new GameBackground();
			this.addChild(bg);
			
			hero = new Hero();
			hero.x = stage.stageWidth/2;
			hero.y = stage.stageWidth/2;
			this.addChild(hero);
		
			startButton = new Button(Assets.getAtlas().getTexture("startButton"));
			startButton.x = stage.stageWidth * 0.5 - startButton.width * 0.5;
			startButton.y = stage.stageHeight * 0.5 - startButton.height * 0.5;
			this.addChild(startButton);
		
			gameArea = new Rectangle(0, 100, stage.stageWidth, stage.stageHeight - 250);
			
		}	
	
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialized():void
		{
			this.visible = true;
			this.addEventListener(Event.ENTER_FRAME, checkElapsed);
			hero.x = -stage.stageWidth;
			hero.y =  stage.stageHeight * 0.5;
			
			gameState = "idle";
			
			playerSpeed = 0;
			hitObstacle = 0;
			
			bg.speed = 0;
			scoreDistance = 0;
			obstacleGapCount = 0;
			
			obstaclesToAnimate = new Vector.<Obstacles>();
			itemsToAnimate = new Vector.<Item>();
			eatParticlesToAnimate = new Vector.<Particles>();
			
			startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
		}
		
		private function onStartButtonClick():void
		{
			startButton.visible = false;
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonClick);
			lauchHero();
		}
		
		private function lauchHero():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(stage);
			touchX = touch.globalX;
			touchY = touch.globalY;
			
		}
		
		private function onGameTick(event:Event):void
		{
			switch(gameState)
			{
				case "idle":
					if(hero.x < stage.stageWidth * 0.5 * 0.5)
					{
						hero.x += ((stage.stageWidth * 0.5 * 0.5 + 10) - hero.x) * 0.05;
						hero.y = stage.stageHeight * 0.5;
						
						playerSpeed += (MIN_SPEED - playerSpeed) * 0.05;
						bg.speed = playerSpeed * elapsed;
					}
					else
					{
						gameState = "flying";
					}
				break;
				
				case "flying":
					
					if(hitObstacle <= 0)
					{
						hero.y -= (hero.y - touchY)*0.1;
						
						if(-(hero.y - touchY) < 150 && -(hero.y - touchY) > -150)
						{
							hero.rotation = deg2rad(-(hero.y - touchY)*0.2);
							
						}
						
						
						if(hero.y > gameArea.bottom - hero.height * 0.5)
						{
							hero.y = gameArea.bottom - hero.height * 0.5;
							hero.rotation = deg2rad(0);
						}
						
						if(hero.y < gameArea.top + hero.height * 0.5)
						{
							hero.y = gameArea.top + hero.height * 0.5;
							hero.rotation = deg2rad(0);
						}
					
					}
					else
					{
						hitObstacle--;
						cameraShake();
					}
					
					playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
					bg.speed = playerSpeed * elapsed;
					scoreDistance += (playerSpeed * elapsed) * 0.1;
					
					if(score < 0)
					{
						score = 0;
					}
					
					total = (scoreDistance/100) * (score/0.5);
					
					feetDistanceText.text = "Distance: " + scoreDistance + " ft";
					scoreItem.text = "Food: " + score;
					scoreTotal.text = "TotalScore: " + total;
					initObstacle();
					animateObstacle();
					
					createFoodItems();
					animateItems();
					animateEatParticles();
					
					break;
				case "over":
					break;
			}	
		}
		
		private function animateEatParticles():void
		{
			for(var i:uint;i<eatParticlesToAnimate.length;i++)
			{
				var eatParticlesToTrack:Particles = eatParticlesToAnimate[i];
				
				if(eatParticlesToTrack)
				{
					eatParticlesToTrack.scaleX -= 0.03;
					eatParticlesToTrack.scaleY = eatParticlesToTrack.scaleX;
					
					eatParticlesToTrack.y -= eatParticlesToTrack.speedY;
					eatParticlesToTrack.speedY -= eatParticlesToTrack.speedY * 0.2;
				
					eatParticlesToTrack.x += eatParticlesToTrack.speedX;
					eatParticlesToTrack.speedX--;
					
					eatParticlesToTrack.rotation += deg2rad(eatParticlesToTrack.spin)
					eatParticlesToTrack.spin *= 1.1;
					
					if(eatParticlesToTrack.scaleY <= 0.02)	
					{
						eatParticlesToAnimate.splice(i, 1);
						this.removeChild(eatParticlesToTrack);
						eatParticlesToTrack = null;
					}
				}
			}
			
		}
		
		private function animateItems():void
		{
			var itemToTrack:Item;
			
			for(var i:uint = 0; i < itemsToAnimate.length; i++)
			{
				itemToTrack = itemsToAnimate[i];
				itemToTrack.x -= playerSpeed * elapsed;
				
				if(itemToTrack.bounds.intersects(hero.bounds))
				{
					
					createEatParticles(itemToTrack);
					
					itemsToAnimate.splice(i, 1);
					score += 1;
					this.removeChild(itemToTrack);
				}
				
				
				if(itemToTrack.x < -50)
				{
					itemsToAnimate.splice(i, 1);
					this.removeChild(itemToTrack);
				}
			}
		}
		
		private function createEatParticles(itemToTrack:Item):void
		{
			var count:int = 5;
			
			while(count > 0)
			{
				count--;
				var eatParticles:Particles = new Particles;
				this.addChild(eatParticles);
				
				eatParticles.x = itemToTrack.x + Math.random()*40 - 20;
				eatParticles.y = itemToTrack.y - Math.random()*40;
				
				eatParticles.speedX = Math.random()*2+1;
				eatParticles.speedY = Math.random()*5;
				eatParticles.spin = Math.random()*15;
				
				eatParticles.scaleX = eatParticles.scaleY = Math.random()*0.3 + 0.3;
				
				eatParticlesToAnimate.push(eatParticles);
			}
			
		}
		
		private function createFoodItems():void
		{
			
			if(Math.random() > 0.95)
			{
				var itemToTrack:Item = new Item (Math.ceil(Math.random()*5));
				itemToTrack.x = stage.stageWidth + 50;
				itemToTrack.y = int(Math.random() * (gameArea.bottom - gameArea.top)) + gameArea.top;	
				this.addChild(itemToTrack);
				
				itemsToAnimate.push(itemToTrack);
			
			}
			
			
		}
		
		private function cameraShake():void
		{
			if (hitObstacle > 0)
			{
				this.x = Math.random()*hitObstacle;
				this.y = Math.random()*hitObstacle;
			}
			else if (x != 0)
			{
				this.x = 0;
				this.y = 0;
			}
		}
		
		private function animateObstacle():void
		{
			var obstaclesToTrack:Obstacles;
			
			for(var i:uint=0;i<obstaclesToAnimate.length;i++)
			{
				obstaclesToTrack = obstaclesToAnimate[i];
				
				if(obstaclesToTrack.alreadyHit == false && obstaclesToTrack.bounds.intersects(hero.bounds))
				{
					obstaclesToTrack.alreadyHit = true;
					obstaclesToTrack.rotation = deg2rad(70);
					hitObstacle = 30;
					playerSpeed *= 0.5;
				}
				
				
				if(obstaclesToTrack.distance > 0)
				{
					obstaclesToTrack.distance -= playerSpeed * elapsed;
				}
				else
				{
					if(obstaclesToTrack.watchOut)
					{
					obstaclesToTrack.watchOut = false;
					}
					obstaclesToTrack.x -= (playerSpeed + obstaclesToTrack.speed)*elapsed;
				}
				if(obstaclesToTrack.x < -obstaclesToTrack.width || gameState == "over")
				{
					obstaclesToAnimate.splice(i, 1);
					this.removeChild(obstaclesToTrack);
						
				}
			}
		}
		
		private function initObstacle():void
		{
			if (obstacleGapCount < 1200)
			{
				obstacleGapCount += playerSpeed * elapsed;
			}
			else if (obstacleGapCount != 0)
			{
				obstacleGapCount = 0;
				createObstacle(Math.ceil(Math.random() * 4),Math.random() * 1000 + 1000);
			}
		}
		
		private function createObstacle(type:Number, distance:Number):void
		{
			var obstacle:Obstacles = new Obstacles(type, distance, true , 300)
			obstacle.x = stage.stageWidth;
			this.addChild(obstacle);
		
			if(type <= 3)
			{
				if (Math.random() > 0.5)
				{
					obstacle.y = gameArea.top;
					obstacle.position = "top";
				}
				else
				{
					obstacle.y = gameArea.bottom - obstacle.height;
					obstacle.position = "bottom";
				}
			}
			else
			{
				obstacle.y = int(Math.random() * (gameArea.bottom - obstacle.height - gameArea.top)) + gameArea.top;
				obstacle.position = "middle";
			}
			obstaclesToAnimate.push(obstacle);
		}
		
		private function checkElapsed(event:Event):void
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer()
			elapsed = (timeCurrent - timePrevious) * 0.001;
		}
	}
}