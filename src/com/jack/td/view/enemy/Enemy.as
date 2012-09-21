package com.jack.td.view.enemy
{
	import com.jack.td.control.Common;
	import com.jack.td.control.EventController;
	import com.jack.td.control.util.Assets;
	import com.jack.td.events.BattleEvent;
	import com.jack.td.util.MathUtil;
	import com.jack.td.view.component.BaseSprite;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.MyMovieClip;
	import starling.extensions.tmx.vo.LineSegment;
	import starling.extensions.tmx.vo.MovePath;
	import starling.textures.Texture;
	
	public class Enemy extends BaseSprite
	{
		private static const ENEMY_PREFIX:String = "enemy_";
		
		private var _name:String;
		private var _type:int;
		private var _enemyIndexInQueue:int;
		private var _curDirection:int;
		private var _spawnPoint:Point;
		private var _destinationPoint:Point;
		private var _curLine:int;
		private var _flag:Number;
		private var _fps:Number;
		private var _curLineAllStep:int;
		private var _speed:Number=5;
		private var _isPlaying:Boolean;
		private var _hp:Number;
		
		// 添加放置Enemy的容器
		// 添加受伤效果
		// 添加死亡效果
		private var path:MovePath;
		private var mc:MyMovieClip;
		
		public function Enemy(enemyType:int, _enemyIndexInQueue:int, fps:Number=12)
		{
			_type = enemyType;
			_fps = fps;
			this._enemyIndexInQueue = _enemyIndexInQueue;
			
			_flag = 0;
			_curLine = 0;
			_curLineAllStep = int.MAX_VALUE;
			_isPlaying = true;
			
			// testonly
			hp = 150;
		}
		
		public function resume():void
		{
			_isPlaying = true;
			mc.play();
		}
		
		public function pause():void
		{
			_isPlaying = false;
			mc.stop();
		}

		public function setMoveRoute(path:MovePath):void
		{
			this.path = path;
			
			_destinationPoint = path.paths[path.paths.length-1].end;
			_spawnPoint = path.paths[0].start;
			
			// 得到敌人的运动方向
			var d:int = getDirectionByLine(0);
			// 设置初始时敌人的面朝方向
			setDirection(d);
		}

		public function hurt(damage:Number):void
		{
			hp -= damage;
			
			playHurtAnimation();
			
			trace("hurt", hp);
		}
		
		public function die():void
		{
			playDieAnimation();
			
			path = null;
			this.removeFromParent(true);
			
			// 派发消息
			var e:BattleEvent = new BattleEvent(BattleEvent.ENEMY_DIE, false, _enemyIndexInQueue);
			EventController.e.dispatchEvent(e);
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		//  private functions
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function showHpBar():void
		{
			
		}
		
		private function playDieAnimation():void
		{
			
		}
		
		private function playHurtAnimation():void
		{
			
		}
		
		public function move(e:Event = null):void
		{
			if(!_isPlaying)
			{
				return;
			}
			
			if(Math.abs(x-_destinationPoint.x)<=1 && Math.abs(y-_destinationPoint.y)<=1)
			{
				reachDestination();
				return;
			}
			
			var p:LineSegment;
			if(_flag >= _curLineAllStep && _curLine <= path.paths.length - 1)
			{
				if(_curLine == path.paths.length - 1)
				{
					reachDestination();
					return;
				}
				
				_flag = 0;
				x = path.paths[_curLine].end.x;
				y = path.paths[_curLine].end.y;
				_curLine++;
				
				// 得到敌人的运动方向
				var d:int = getDirectionByLine(_curLine);;
				// 设置敌人的运动方向
				setDirection(d);
			}
			
			p = path.paths[_curLine]
			_curLineAllStep = p.length/_speed;
			if(MathUtil.isOnLine(x, y, p))
			{
				var ax:Number = x;
				var ay:Number = y;
				
				var xx:Number = _speed*Math.cos(p.radian);
				var yy:Number = _speed*Math.sin(p.radian);
				
				if(p.end.x < p.start.x)
				{
					xx = -xx;
				}
				
				if(p.end.y < p.start.y)
				{
					yy = -yy;
				}
				
				ax += xx;
				ay += yy;
				
				x = ax;
				y = ay;
				
				_flag++;
			}
		}
		
		/**
		 * 根据线段的索引得到此线段对应的方向，从而设置线段上的所有敌人都面朝此向。
		 * @param lineIndex
		 * @return 
		 */
		private function getDirectionByLine(lineIndex:int):int
		{
			var p:LineSegment = path.paths[lineIndex];;
			// 设置敌人的运动方向
			var angle:Number = p.angle;
			var d:int;
			
			//  ["w", "nw", "n", "ne", "e", "se", "s", "sw"]
			if(p.end.x > p.start.x)
			{
				if(p.end.y < p.start.y)
				{
					if(angle <= 22.5)
						d = 4;
					else if(angle <= 67.5)
						d = 3;
					else
						d = 2;
				}
				else
				{
					if(angle <= 22.5)
						d = 4;
					else if(angle <= 67.5)
						d = 5;
					else
						d = 6;
				}
			}
			else
			{
				if(p.end.y < p.start.y)
				{
					if(angle <= 22.5)
						d = 0;
					else if(angle <= 67.5)
						d = 1;
					else
						d = 2;
				}
				else
				{
					if(angle <= 22.5)
						d = 0;
					else if(angle <= 67.5)
						d = 7;
					else
						d = 6;
				}
			}
			
			return d;
		}
		
		/**
		 * 设置敌人当前面对的方向,通常根据移动的路径方向来设置.
		 * @param dir  方向索引,参见: ["w", "nw", "n", "ne", "e", "se", "s", "sw"]
		 */
		private function setDirection(dir:int):void
		{
			//trace("setDirection", Common.DIRECTIONS[dir]);
			_curDirection = dir;
			
			// 格式类似: enemy_1_se_
			var textureAtlasPrefix:String = ENEMY_PREFIX + String(_type) + "_" + Common.DIRECTIONS[_curDirection] + "_";
			var textures:Vector.<Texture> = Assets.getTextures(textureAtlasPrefix);
			
			if(mc)
			{
				// 更新不同方向的纹理集合
				mc.resetTextures(textures, _fps);
			}
			else
			{
				// 创建敌人
				mc = new MyMovieClip(textures, _fps);
				mc.loop = true;
				addChild(mc);
				Starling.juggler.add(mc);
				
				// 设置敌人Sprite的注册点为中心店
				mc.scaleX=mc.scaleY=2;
				this.pivotX = this.width/2;
				this.pivotY = this.height/2;
			}
		}
		
		private function reachDestination():void
		{
			path = null;
			this.removeFromParent(true);
			
			// 派发消息
			var e:BattleEvent = new BattleEvent(BattleEvent.ENEMY_REACH_DESTINATION, false, _enemyIndexInQueue);
			EventController.e.dispatchEvent(e);
		}

		public function get enemyIndexInQueue():int
		{
			return _enemyIndexInQueue;
		}

		public function get type():int
		{
			return _type;
		}

		public function get hp():Number
		{
			return _hp;
		}

		public function set hp(value:Number):void
		{
			_hp = value;
		}
		
		public function get isDead():Boolean
		{
			return _hp <= 0;
		}
		
	}
}