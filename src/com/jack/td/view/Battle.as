package com.jack.td.view
{
	import com.gdlib.util.Delay;
	import com.gdlib.util.RandomUtil;
	import com.jack.td.control.EventController;
	import com.jack.td.control.Global;
	import com.jack.td.control.gesture.PanGestureController;
	import com.jack.td.events.BattleEvent;
	import com.jack.td.view.bullet.Bullet;
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
		public var bulletList:Vector.<Bullet> = new Vector.<Bullet>();
		
		private var tmpTime:Number;
		private var nowTime:Number;
		private var _spawnEnemyNum:int;
		private var _towerNum:int;
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
			_towerNum = 0;
			
			// 监听事件
			addEventListener(TouchEvent.TOUCH, onBattleViewClick);
			
			EventController.e.addEventListener(BattleEvent.ENEMY_DIE, onEnemyDie);
			EventController.e.addEventListener(BattleEvent.ENEMY_HURT, onEnemyHurt);
			EventController.e.addEventListener(BattleEvent.ENEMY_REACH_DESTINATION, onEnemyReachDestination);
			
			EventController.e.addEventListener(BattleEvent.BULLET_MOVE_OUT, onBulletMoveOutRange);
		}
		
		protected function onBattleViewClick(e:TouchEvent):void
		{
			var touch:Touch=e.getTouch(this);
			
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				// 增加炮塔
				addAnTower(1, new Point(touch.globalX/Global.contentScaleXFactor, touch.globalY/Global.contentScaleYFactor), 36);
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
			// 增加敌人
			if(nowTime - tmpTime >= 3000)
			{
				tmpTime = nowTime;
				addNewEnemy();
			}
			
			var i:uint;
			var j:uint;
			var k:uint;
			
			var enemy:Enemy;
			// 每一帧移动敌人
			for (i = 0; i < enemyList.length; i++) 
			{
				enemy = enemyList[i];
				// 更新敌人的位置
				enemy.move();
				// 计算敌人和炮塔是否交火
				for (j = 0; j < towerList.length; j++) 
				{
					towerList[j].detect(enemy.x, enemy.y, enemy.type);
				}
				// 计算敌人是否和子弹碰撞
				var bullet:Bullet
				for (k = 0; k < bulletList.length; k++) 
				{
					bullet = bulletList[k];
					bullet.move();
					// 如果子弹和敌人有碰撞
					if(bullet.bounds.intersects(enemy.bounds))
					//if(enemy.hitTest(new Point(bullet.getBounds(enemy).x, bullet.getBounds(enemy).y)))
					{
						var damage:Number = RandomUtil.integer(bullet.minDamage, bullet.maxDamage);
						enemy.hurt(damage);
						// 判断敌人是否死亡
						if(enemy.isDead)
						{
							enemy.die();
						}
						
						// 从bulletList中删除这个敌人的记录
						var len:int = bulletList.length;
						for (var m:int = 0; m < len; m++) 
						{
							if(bulletList[m].bulletIndexInQueue == bullet.bulletIndexInQueue)
							{
								bulletList.splice(m, 1);
								break;
							}
						}
						// 删除子弹
						bullet.removeFromParent(true);
						bullet = null;
					}
				}
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
			var tower:Tower = new Tower(enemyId, _towerNum, fps);
			tower.x = bornPlace.x;
			tower.y = bornPlace.y;
			
			addChild(tower);
			towerList.push(tower);
			_towerNum++;
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
			
			// 更新ui显示
		}
		
		// 敌人死亡后的处理
		private function onEnemyDie(e:BattleEvent):void
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
			
			// 更新ui显示
		}
		
		// 敌人受到伤害后的处理
		private function onEnemyHurt(e:BattleEvent):void
		{
			
		}
		
		// 当子弹运行到最大距离时
		private function onBulletMoveOutRange(e:BattleEvent):void
		{
			var bulletIndexInQueue:int = int(e.data);
			
			// 从bulletList中删除这个敌人的记录
			var len:int = bulletList.length;
			for (var i:int = 0; i < len; i++) 
			{
				if(bulletList[i].bulletIndexInQueue == bulletIndexInQueue)
				{
					bulletList[i].removeFromParent(true);
					bulletList.splice(i, 1);
					break;
				}
			}
		}
		
	}
}