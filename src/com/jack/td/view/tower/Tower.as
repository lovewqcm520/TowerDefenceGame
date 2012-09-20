package com.jack.td.view.tower
{
	import com.jack.td.control.util.Assets;
	import com.jack.td.view.component.BaseSprite;
	
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.extensions.MyMovieClip;
	import starling.textures.Texture;
	
	public class Tower extends BaseSprite
	{
		private static const TOWER_PREFIX:String = "tower_";
		
		protected var _maxLevel:int;
		protected var _curLevel:int;
		protected var _id:int;
		protected var _fps:int;
		protected var _indexInTowerQueue:int;
		protected var _name:String;
		protected var _desc:String;
		protected var _minDamage:Number;
		protected var _maxDamage:Number;
		protected var _attackRange:Rectangle;
		protected var _sellPrice:Number;
		protected var _curDirection:int;
		protected var _isPlaying:Boolean;
		
		protected var mc:MyMovieClip;
		
		public function Tower(towerId:int, _indexInTowerQueue:int, fps:Number=12)
		{
			_id = towerId;
			_fps = fps;
			this._indexInTowerQueue = _indexInTowerQueue;
			_isPlaying = true;
			
			setTowardAngle();
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
		
		public function shoot():void
		{
			
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
		
		private function setTowardAngle(dir:int=-1):void
		{
			_curDirection = dir == -1 ? 0 : dir;
			
			// 格式类似: enemy_1_se_
			var textureAtlasPrefix:String = TOWER_PREFIX + String(_id) + "_";
			var textures:Vector.<Texture> = Assets.getTextures(textureAtlasPrefix);
			
			if(mc)
			{
				mc.currentFrame = _curDirection;
			}
			else
			{
				// 创建敌人
				mc = new MyMovieClip(textures, _fps);
				mc.stop();
				addChild(mc);
				Starling.juggler.add(mc);
				
				// 设置敌人Sprite的注册点为中心店
				mc.scaleX=mc.scaleY=2;
				this.pivotX = this.width/2;
				this.pivotY = this.height/2;
			}
		}
	}
}