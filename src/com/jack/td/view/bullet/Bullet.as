package com.jack.td.view.bullet
{
	import com.jack.td.control.EventController;
	import com.jack.td.control.util.Assets;
	import com.jack.td.events.BattleEvent;
	import com.jack.td.util.MathUtil;
	import com.jack.td.view.component.BaseSprite;
	
	import starling.core.Starling;
	import starling.extensions.MyMovieClip;
	import starling.textures.Texture;
	
	public class Bullet extends BaseSprite
	{
		private static const BULLET_PREFIX:String = "bullet_";
		
		// 子弹的类型
		private var _type:int;
		private var _fps:Number;
		// 子弹移动的速度
		private var _speed:Number;		
		// 子弹移动的目标x坐标
		private var _desX:Number;
		// 子弹移动的目标y坐标
		private var _desY:Number;
		
		private var mc:MyMovieClip;
		private var _angle:Number;
		private var _startX:Number;
		private var _startY:Number;
		private var _dis:Number;
		private var _minDamage:Number;
		private var _maxDamage:Number;
		private var _bulletIndexInQueue:int;

		public function Bullet(bulletType:int, bulletIndexInQueue:int, fps:Number=36)
		{
			super();
			
			_type = bulletType;
			_fps = fps;
			_bulletIndexInQueue = bulletIndexInQueue;
			
			initBullet();
		}
		
		public function setInfo(startX:Number, startY:Number, desX:Number, desY:Number, speed:Number, angle:Number):void
		{
			_startX = startX;
			_startY = startY;
			_speed = speed;
			_angle = angle;
			_desX = desX;
			_desY = desY;
			
			_dis = MathUtil.point2Point(_startX, _startY, _desX, _desY);
		}
		
		public function move():void
		{
			// 移动子弹
			var ax:Number = Math.abs(_speed*Math.cos(MathUtil.ang2Radian(_angle)));
			var ay:Number = Math.abs(_speed*Math.sin(MathUtil.ang2Radian(_angle)));
			
			if(_desX < _startX)
			{
				ax = -ax;
				if(_desY < _startY)
				{
					ay = -ay
				}
				else
				{
					ay = ay;
				}
			}
			else
			{
				ax = ax;
				if(_desY < _startY)
				{
					ay = -ay
				}
				else
				{
					ay = ay;
				}
			}
			
			x += ax;
			y += ay;
			
			// 子弹已经达到终点， 删除子弹
			if(MathUtil.point2Point(x, y, _startX, _startY) >= _dis)
			{
				this.removeFromParent(true);
				
				// 派发消息
				var e:BattleEvent = new BattleEvent(BattleEvent.BULLET_MOVE_OUT, false, _bulletIndexInQueue);
				EventController.e.dispatchEvent(e);
			}
		}
		
		public function resume():void
		{
			
		}
		
		public function pause():void
		{
			
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
		}		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		//  private functions
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// 初始化子弹
		private function initBullet():void
		{
			// 格式类似: bullet_1_
			var textureAtlasPrefix:String = BULLET_PREFIX + String(_type) + "_";
			var textures:Vector.<Texture> = Assets.getTextures(textureAtlasPrefix);
			
			// 创建子弹
			mc = new MyMovieClip(textures, _fps);
			mc.loop = true;
			addChild(mc);
			Starling.juggler.add(mc);
			
			// 设置子弹的注册点为中心点
			mc.scaleX=mc.scaleY=2;
			this.pivotX = this.width/2;
			this.pivotY = this.height/2;
		}

		public function get minDamage():Number
		{
			return _minDamage;
		}

		public function set minDamage(value:Number):void
		{
			_minDamage = value;
		}

		public function get maxDamage():Number
		{
			return _maxDamage;
		}

		public function set maxDamage(value:Number):void
		{
			_maxDamage = value;
		}

		public function get bulletIndexInQueue():int
		{
			return _bulletIndexInQueue;
		}

		public function set bulletIndexInQueue(value:int):void
		{
			_bulletIndexInQueue = value;
		}

		
	}
}