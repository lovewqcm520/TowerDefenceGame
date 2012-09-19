package com.jack.td.view.screen
{
	import com.jack.td.control.Common;
	import com.jack.td.view.component.BaseSprite;
	
	import flash.geom.Point;
	
	import starling.events.Event;
	import starling.extensions.tmx.TMXLayer;
	import starling.extensions.tmx.TMXTileMap;
	import starling.extensions.tmx.TiledObject;
	import starling.extensions.tmx.vo.LineSegment;
	import starling.extensions.tmx.vo.MovePath;
	
	public class TiledMap extends BaseSprite
	{
		private static const MOVE_PATH:String = "movePath";
		private static const ENEMY_SPAWN:String = "enemyStartPoint";
		
		private var mapName:String;
		private var tmx:TMXTileMap;
		
		public var movePaths:Vector.<MovePath> = new Vector.<MovePath>();
		public var birthPlace:Point;
		
		public function TiledMap(mapName:String)
		{
			this.mapName = mapName;
			
			init();
		}
		
		
		private function getMovePath():void
		{
			var path:Vector.<LineSegment> = tmx.getObject(MOVE_PATH).getLineSegments();
			var movePath:MovePath = new MovePath();
			movePath.paths = path;
			
			movePaths.push(movePath);
		}
		
		private function getBirthPlace():void
		{
			var o:TiledObject = tmx.getObject(ENEMY_SPAWN); 
			
			birthPlace = new Point();
			birthPlace.x = o.x + o.width/2;
			birthPlace.y = o.y + o.height/2;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		//  private functions
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		private function init():void
		{
			tmx = new TMXTileMap();
			tmx.addEventListener(Event.COMPLETE, drawLayers);
			
			tmx.load(mapName);
		}
		
		private function drawLayers(e:Event):void
		{
			tmx.removeEventListener(Event.COMPLETE, drawLayers);
			
			var layers:Vector.<TMXLayer> = tmx.layers();
			var nLayer:int = layers.length;
			
			for (var i:int = 0; i < nLayer; i++) 
			{
				addChild(layers[i].getHolder());
			}
			
			if(!this.stage)
				this.addEventListener(Event.ADDED_TO_STAGE, onMapAddedToStage);
			else
				onMapAddedToStage();
			
			// 获取移动路径
			getMovePath();
			// 获取敌人出生地点
			getBirthPlace();
			
			// 分派地图渲染完成的消息
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onMapAddedToStage(e:Event = null):void
		{
		}
	}
}