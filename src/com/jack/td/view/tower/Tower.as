package com.jack.td.view.tower
{
	import com.jack.td.Game;
	import com.jack.td.control.util.Assets;
	import com.jack.td.util.MathUtil;
	import com.jack.td.view.bullet.Bullet;
	import com.jack.td.view.component.BaseSprite;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.extensions.MyMovieClip;
	import starling.textures.Texture;
	
	public class Tower extends BaseSprite
	{
		private static const TOWER_PREFIX:String = "tower_";
		private static var bulletNum:int = 0;
		
		private static const ATTACK_RANGE_CIRCLE:int = 1;
		private static const ATTACK_RANGE_RECTANGLE:int = 2;
		
		private static const ATTACK_SINGLE:int = 1;
		private static const ATTACK_RANGE:int = 1;
		
		private static const ATTACK_RANGE_CIRCLE_COLOR:uint = 0x8ccd94;
		private static const ATTACK_RANGE_CIRCLE_ALPHA:Number = 0.35;
		
		private static const ATTACK_RANGE_CIRCLE_DISABLE_COLOR:uint = 0xff2f2f;
		private static const ATTACK_RANGE_CIRCLE_DISABLE_ALPHA:Number = 0.35;
		
		private static var _attackRangeCircle:Image;
		private static var _attackRangeDisableCircle:Image;
		
		protected var _maxLevel:int;
		protected var _curLevel:int;
		protected var _towerType:int;
		protected var _fps:int;
		protected var _indexInTowerQueue:int;
		protected var _name:String;
		protected var _desc:String;
		protected var _minDamage:Number=10;
		protected var _maxDamage:Number=10;
		protected var _attackRange:Rectangle = new Rectangle(0, 0, 300, 300);
		protected var _sellPrice:Number;
		protected var _curAngle:int;
		protected var _isPlaying:Boolean;
		protected var _centerPoint:Point = new Point();
		protected var _radius:Number;
		protected var _attackRangeType:int;
		protected var _attackType:int;
		protected var _isFiring:Boolean=false;
		protected var _perFrameAngle:Number;
		protected var _attackInterval:Number = 100;
		
		
		protected var mc:MyMovieClip;
		private var _enemyCoords:Point = new Point();
		private var _lastShoot:Number=0;
		
		public function Tower(towerType:int, _indexInTowerQueue:int, fps:Number=12)
		{
			_towerType = towerType;
			_fps = fps;
			this._indexInTowerQueue = _indexInTowerQueue;
			_isPlaying = true;
			
			_attackRangeType = ATTACK_RANGE_CIRCLE;
			setTowardAngle();
			updateTowerData();
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
		
		public function detect(enemyCoordsX:Number, enemyCoordsY:Number, enemyType:int):void
		{
			if(isCanShoot(enemyType))
			{
				// 判断敌人是否在射程以内
				if(_attackRangeType == ATTACK_RANGE_CIRCLE)
				{
					_centerPoint.x = this.x;
					_centerPoint.y = this.y;
					_enemyCoords.x = enemyCoordsX;
					_enemyCoords.y = enemyCoordsY;
					if(MathUtil.pointInCircle(enemyCoordsX, enemyCoordsY, _centerPoint.x, _centerPoint.y, _radius))
					{
						// 跟随敌人移动转动塔炮
						var a:Number = MathUtil.getLineSlopeAngle(_enemyCoords, _centerPoint);
						var rotateAngle:Number;
						if(enemyCoordsX < _centerPoint.x)
						{
							if(enemyCoordsY < _centerPoint.y)
							{
								rotateAngle = a;
							}
							else
							{
								rotateAngle = 360 - a;
							}
						}
						else
						{
							if(enemyCoordsY < _centerPoint.y)
							{
								rotateAngle = 180 - a;
							}
							else
							{
								rotateAngle = 181 + a;
							}
						}
						
						setTowardAngle(rotateAngle);
						
						// 判断是否到了开火的时间
						if(getTimer() - _lastShoot >= _attackInterval)
						{
							// 开火
							shoot(enemyCoordsX, enemyCoordsY, a);
							// 播放开火音效
						}
					}
				}
			}
		}
		
		public function shoot(enemyCoordsX:Number, enemyCoordsY:Number, rotateAngle:Number):void
		{
			//trace("shoot", enemyCoordsX, enemyCoordsY);
			_lastShoot = getTimer();
			
			var bullet:Bullet = new Bullet(1, bulletNum);
			bullet.setInfo(this.x, this.y, enemyCoordsX, enemyCoordsY, 20, rotateAngle);
			bullet.minDamage = _minDamage;
			bullet.maxDamage = _maxDamage;
			bullet.x = this.x;
			bullet.y = this.y;
			Game.getInstance().battle.addChild(bullet);
			Game.getInstance().battle.bulletList.push(bullet);
			bulletNum++;
		}
		
		public function upgrade():void
		{
			
		}
		
		public function sell():void
		{
			
		}
		
		public function destoryByEnemy():void
		{
			
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		//  private functions
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 判断敌人是否为可攻击的类型，如果塔炮只能对空，敌人为地面部队，则无法攻击。
		 * @param enemyType
		 * @return 
		 */
		private function isCanShoot(enemyType:int):Boolean
		{
			return true;
		}
		
		private function updateTowerData():void
		{
			if(_attackRangeType == ATTACK_RANGE_CIRCLE)
			{
				_radius = _attackRange.width;
			}
			else if(_attackRangeType == ATTACK_RANGE_RECTANGLE)
			{
				
			}
		}
		
		/**
		 * 显示炮塔的攻击范围.
		 * @param enable	此时炮台是可用还是禁用状态
		 */
		private function showAttackRange(enable:Boolean):void
		{
			if(enable)
			{
				if(!_attackRangeCircle)
				{
					_attackRangeCircle = Assets.getImage("tower_range");
				}
				
				// 添加范围指示圆形到炮台
				_attackRangeCircle.width = _attackRange.width*2;
				_attackRangeCircle.height = _attackRange.height*2;
				_attackRangeCircle.x = mc.x + (mc.width-_attackRangeCircle.width)/2;
				_attackRangeCircle.y = mc.y + (mc.height-_attackRangeCircle.height)/2;
				addChild(_attackRangeCircle);
			}
			else
			{
				if(!_attackRangeDisableCircle)
				{
					_attackRangeDisableCircle = Assets.getImage("tower_range");
				}
				
				// 添加范围指示圆形到炮台
				_attackRangeDisableCircle.width = _attackRange.width*2;
				_attackRangeDisableCircle.height = _attackRange.height*2;
				_attackRangeDisableCircle.x = mc.x + (mc.width-_attackRangeDisableCircle.width)/2;
				_attackRangeDisableCircle.y = mc.y + (mc.height-_attackRangeDisableCircle.height)/2;
				addChild(_attackRangeDisableCircle);
			}
		}
		
		private function setTowardAngle(a:int=-1):void
		{
			_curAngle = a == -1 ? 0 : a;
			
			if(mc)
			{
				var nf:int = _curAngle/_perFrameAngle;
				mc.currentFrame = nf > mc.numFrames ? mc.numFrames : nf;
			}
			else
			{
				// 格式类似: tower_1_
				var textureAtlasPrefix:String = TOWER_PREFIX + String(_towerType) + "_";
				var textures:Vector.<Texture> = Assets.getTextures(textureAtlasPrefix);
				// 创建炮塔
				mc = new MyMovieClip(textures, _fps);
				mc.stop();
				addChild(mc);
				Starling.juggler.add(mc);
				
				// 设置敌人Sprite的注册点为中心店
				mc.scaleX=mc.scaleY=2;
				this.pivotX = this.width/2;
				this.pivotY = this.height/2;
				
				// 计算出炮塔精灵毎帧代表的转动角度
				_perFrameAngle = 360/mc.numFrames;
				
				// test
				showAttackRange(true);
			}
		}
	}
}