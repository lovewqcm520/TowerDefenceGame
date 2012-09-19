package com.jack.td.view.enemy
{
	import com.jack.td.control.Common;
	import com.jack.td.control.util.Assets;
	import com.jack.td.util.MathUtil;
	import com.jack.td.view.component.BaseSprite;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.extensions.tmx.vo.LineSegment;
	import starling.extensions.tmx.vo.MovePath;
	import starling.textures.Texture;
	
	public class Enemy extends BaseSprite
	{
		private static const ENEMY_PREFIX:String = "enemy_";
		
		private var _name:String;
		private var _id:int;
		private var _curDirection:int;
		private var _spawnPoint:Point;
		private var _destinationPoint:Point;
		private var _curLine:int;
		private var flag:Number = 0;
		private var _fps:Number;
		private var _curLineAllStep:int=int.MAX_VALUE;
		
		private var _curTextures:Vector.<Texture>;	
		// 添加放置Enemy的容器
		// 添加受伤效果
		// 添加死亡效果
		private var path:MovePath;
		
		private var mc:MovieClip;
		
		public function Enemy(enemyId:int, defaultDirection:int, fps:Number=12)
		{
			_id = enemyId;
			_curDirection = defaultDirection;
			_fps=fps;
			
			// enemy_1_se
			setDirection(_curDirection);
			
			this.pivotX = this.width/2;
			this.pivotY = this.height/2;
		}
		
		public function move():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_curLine = 0;
		}

		private function onEnterFrame(e:Event):void
		{
			// dispose the enemy?
			if(Math.abs(x-_destinationPoint.x)<=1 && Math.abs(y-_destinationPoint.y)<=1)
			{
				kill();
				return;
			}
			
			var p:LineSegment;
			if(flag >= _curLineAllStep && _curLine < path.paths.length - 1)
			{
				flag = 0;
				x = path.paths[_curLine].end.x;
				y = path.paths[_curLine].end.y;
				_curLine++;
				
				p = path.paths[_curLine];
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
				
				// 设置敌人的运动方向
				setDirection(d);
			}
			
			var speed:Number = 5;
			p = path.paths[_curLine]
			_curLineAllStep = p.length/speed;
			if(MathUtil.isOnLine(x, y, p))
			{
				var ax:Number = x;
				var ay:Number = y;
				
				var xx:Number = speed*Math.cos(p.radian);
				var yy:Number = speed*Math.sin(p.radian);
				
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
				
				flag++;
			}
		}
		
		public function setDirection(dir:int):void
		{
			trace("setDirection", Common.DIRECTIONS[dir]);
			_curDirection = dir;
			
			if(mc)
			{
				mc.removeFromParent(true);
				mc = null;
			}
			
			// enemy_1_se
			var textureAtlasPrefix:String = ENEMY_PREFIX + String(_id) + "_" + Common.DIRECTIONS[_curDirection];
			var textures:Vector.<Texture> = Assets.getTextures(textureAtlasPrefix);
			
			mc = new MovieClip(textures, _fps);
			mc.loop = true;
			addChild(mc);
			Starling.juggler.add(mc);
		}
		
		public function setMoveRoute(path:MovePath):void
		{
			this.path = path;
			
			_destinationPoint = path.paths[path.paths.length-1].end;
		}
		
		public function setSpawnPosition(p:Point):void
		{
			_spawnPoint = p;
		}
		
		public function setDestinationPosition(p:Point):void
		{
		}
		
		public function kill():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeFromParent(true);
		}
		
		public function suicide():void
		{
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		//  private functions
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
	}
}