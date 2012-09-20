package com.jack.td.control.gesture
{
	import com.jack.td.control.Common;
	import com.jack.td.log.Log;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.PanGesture;
	
	import starling.display.DisplayObject;

	public class PanGestureController
	{
		private var pan:PanGesture;
		private var map:DisplayObject;
		
		public function PanGestureController()
		{
		}
		
		public function activate(target:DisplayObject):void
		{
			this.map = target;
			if(!pan)
			{
				pan = new PanGesture(target);
				pan.maxNumTouchesRequired = 2;
			}
			pan.addEventListener(GestureEvent.GESTURE_BEGAN, onPanGesture);
			pan.addEventListener(GestureEvent.GESTURE_CHANGED, onPanGesture);
		}
		
		public function deactivate():void
		{
			if(pan)
			{
				pan.removeEventListener(GestureEvent.GESTURE_BEGAN, onPanGesture);
				pan.removeEventListener(GestureEvent.GESTURE_CHANGED, onPanGesture);
				pan.dispose();
				pan = null;
			}
		}
		
		protected function onPanGesture(event:GestureEvent):void
		{
			const gesture:PanGesture = event.target as PanGesture;
			
			map.x = map.x + gesture.offsetX;
			map.x = map.x > 0 ? 0 : map.x;	
			
			if(map.width > Common.FULLSCREEN_WIDTH)
			{
				map.x = (map.x + map.width) < Common.FULLSCREEN_WIDTH ? Common.FULLSCREEN_WIDTH - map.width : map.x;
			}
			else
			{
				map.x = 0;
			}
			
			map.y = map.y + gesture.offsetY;
			map.y = map.y > 0 ? 0 : map.y;
			if(map.height > Common.FULLSCREEN_HEIGHT)
			{
				map.y = (map.y + map.height) < Common.FULLSCREEN_HEIGHT ? Common.FULLSCREEN_HEIGHT - map.height : map.y;
			}
			else
			{
				map.y = 0;
			}
			
			Log.traced(gesture.offsetX, gesture.offsetY, gesture.location, gesture.touchesCount);
		}
		
	}
}