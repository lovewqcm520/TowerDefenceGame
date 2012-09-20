package com.jack.td.view
{
	import com.gdlib.util.Delay;
	import com.jack.td.control.EventController;
	import com.jack.td.control.Global;
	import com.jack.td.control.gesture.PanGestureController;
	import com.jack.td.events.BattleEvent;
	import com.jack.td.view.component.BaseSprite;
	import com.jack.td.view.enemy.Enemy;
	import com.jack.td.view.screen.TiledMap;
	import com.jack.td.view.tower.Tower;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Battle extends BaseSprite
	{
		private var tiledMap:TiledMap;
		private var enemyList:Vector.<Enemy> = new Vector.<Enemy>();
		private var towerList:Vector.<Tower> = new Vector.<Tower>();
		
		private var tmpTime:Number;
		private var nowTime:Number;
		private var _spawnEnemyNum:int;
		private var _TowerNum:int;
		private var _playing:Boolean=true;
		
		public function Battle()
		{
			super();
			
			init();
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		//  private functions
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			tiledMap = new TiledMap("assets/tmx_test/test.tmx");
			tiledMap.addEventListener(Event.COMPLETE, onMapLoaded);
			tiledMap.onClick(onMapClick);
			addChild(tiledMap);
			
			// add zoom gesture
//			var zoomGesture:ZoomGestureController = new ZoomGestureController();
//			zoomGesture.activate(tiledMap);
			
			var panGesture:PanGestureController = new PanGestureController();
			panGesture.activate(tiledMap);
			
			_spawnEnemyNum = 0;
			_TowerNum = 0;
			
			// 监听事件
			addEventListener(TouchEvent.TOUCH, onBattleViewClick);
			
			EventController.e.addEventListener(BattleEvent.ENEMY_DIE, onEnemyDie);
			EventController.e.addEventListener(BattleEvent.ENEMY_HURT, onEnemyHurt);
			EventController.e.addEventListener(BattleEvent.ENEMY_REACH_DESTINATION, onEnemyReachDestination);
		}
		
		protected function onBattleViewClick(e:TouchEvent):void
		{
			var touch:Touch=e.getTouch(this);
			
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				// 增加炮塔
				//addAnTower(1, new Point(touch.globalX/Global.contentScaleXFactor, touch.globalY/Global.contentScaleYFactor));
			}
		}
		
		private function onMapClick():void
		{
//			_playing = !_playing;
//			
//			if(_playing)
//				resume();
//			else
//				pause();
			
			
		}
		
		private function onEnterFrame(e:Event):void
		{
			nowTime = getTimer();
			if(nowTime - tmpTime >= 250)
			{
				tmpTime = nowTime;
				addNewEnemy();
			}
			
			for (var i:int = 0; i < enemyList.length; i++) 
			{
				enemyList[i].move();
			}
		}
		
		private function addWaves():void
		{
			
		}
		
		private function start():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			tmpTime = getTimer();
		}
		
		private function pause():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			for (var i:int = 0; i < enemyList.length; i++) 
			{
				enemyList[i].pause();
			}
		}
		
		private function resume():void
		{
			for (var i:int = 0; i < enemyList.length; i++) 
			{
				enemyList[i].resume();
			}
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			tmpTime = getTimer();
		}
		
		private function onMapLoaded(e:Event):void
		{
			Delay.doIt(3000, start);
		}
		
		private function addNewEnemy():void
		{
			// add a enemy on the map
			for (var i:int = 0; i < 1; i++) 
			{
				spawnAnEnemy(1, tiledMap.movePaths[0].paths[0].start, 36);
			}
		}
		
		private function spawnAnEnemy(enemyId:int, bornPlace:Point, fps:Number=12):void
		{
			var enemy:Enemy = new Enemy(enemyId, _spawnEnemyNum, fps);
			enemy.setMoveRoute(tiledMap.movePaths[0]);
			enemy.x = bornPlace.x;
			enemy.y = bornPlace.y;
			
			addChild(enemy);
			enemyList.push(enemy);
			_spawnEnemyNum++;
			
			// 开始移动敌人
			//enemy.start();
		}
		
		private function addAnTower(enemyId:int, bornPlace:Point, fps:Number=12):void
		{
			var tower:Tower = new Tower(enemyId, _TowerNum, fps);
			tower.x = bornPlace.x;
			tower.y = bornPlace.y;
			
			addChild(tower);
			towerList.push(tower);
			_TowerNum++;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		//  事件响应函数
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// 敌人到达终点后的处理
		private function onEnemyReachDestination(e:BattleEvent):void
		{
			var enemyIndexInQueue:int = int(e.data);
			
			// 从enemyList中删除这个敌人的记录
			var len:int = enemyList.length;
			for (var i:int = 0; i < len; i++) 
			{
				if(enemyList[i].enemyIndexInQueue == enemyIndexInQueue)
				{
					enemyList.splice(i, 1);
					break;
				}
			}
		}
		
		// 敌人死亡后的处理
		private function onEnemyDie(e:BattleEvent):void
		{
			
		}
		
		// 敌人受到伤害后的处理
		private function onEnemyHurt(e:BattleEvent):void
		{
			
		}
		

		
	}
}