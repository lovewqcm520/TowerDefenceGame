package com.jack.td.view
{
	import com.gdlib.util.Delay;
	import com.jack.td.control.gesture.PanGestureController;
	import com.jack.td.view.component.BaseSprite;
	import com.jack.td.view.enemy.Enemy;
	import com.jack.td.view.screen.TiledMap;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class Battle extends BaseSprite
	{
		private var tiledMap:TiledMap;
		
		private var tmpTime:Number;
		private var nowTime:Number;
		public function Battle()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			tiledMap = new TiledMap("assets/tmx_test/test.tmx");
			tiledMap.addEventListener(Event.COMPLETE, onMapLoaded);
			addChild(tiledMap);
			
			// add zoom gesture
//			var zoomGesture:ZoomGestureController = new ZoomGestureController();
//			zoomGesture.activate(tiledMap);
			
			var panGesture:PanGestureController = new PanGestureController();
			panGesture.activate(tiledMap);
			
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			tmpTime = getTimer();
		}
		
		private function onEnterFrame(e:Event):void
		{
			nowTime = getTimer();
			if(nowTime - tmpTime >= 250)
			{
				tmpTime = nowTime;
				start();
			}
		}
		
		private function onMapLoaded(e:Event):void
		{
			Delay.doIt(3000, start);
		}
		
		private function start():void
		{
			// add a enemy on the map
			for (var i:int = 0; i < 1; i++) 
			{
				spawnAnEnemy(1, 3, tiledMap.movePaths[0].paths[0].start, 36);
			}
		}
		
		private function spawnAnEnemy(enemyId:int, defaultDirection:int, bornPlace:Point, fps:Number=12):void
		{
			var enemy:Enemy = new Enemy(enemyId, defaultDirection, fps);
			enemy.scaleX = enemy.scaleY = 2;
			enemy.x = bornPlace.x;
			enemy.y = bornPlace.y;
			addChild(enemy);
			
			enemy.setSpawnPosition(bornPlace);
			enemy.setMoveRoute(tiledMap.movePaths[0]);
			enemy.move();
		}
		
	}
}