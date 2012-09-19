package com.jack.td.view.enemy
{
	import flash.geom.Point;

	public interface IEnemy
	{
		function setDirection(dir:int):void;
		function setMoveRoute():void;
		function setSpawnPosition(p:Point):void;
		function setDestinationPosition(p:Point):void;
		
		function kill():void;
		function suicide():void;
		function pause():void;
	}
}