package com.jack.td.events
{
	import starling.events.Event;
	
	public class BattleEvent extends Event
	{
		// 当小日本受到伤害时分派
		public static const ENEMY_HURT:String = "enemy_hurt";
		
		// 当小日本死亡时分派
		public static const ENEMY_DIE:String = "enemy_die";
		
		// 当小日本到达终点时分派 （爱国玩家可千万不要让狗日的到达终点）
		public static const ENEMY_REACH_DESTINATION:String = "enemy_reach_destination";
		
		public function BattleEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}