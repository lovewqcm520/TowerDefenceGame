package com.jack.td.control.gesture
{
	import com.jack.td.control.Common;
	import com.jack.td.log.Log;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.ZoomGesture;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class ZoomGestureController
	{
		private var zoom:ZoomGesture;
		private var target:DisplayObject;
		
		public function ZoomGestureController()
		{
		}
		
		public function activate(target:DisplayObject):void
		{
			this.target = target;
			if(!zoom)
			{
				zoom = new ZoomGesture(target);
			}
			zoom.addEventListener(GestureEvent.GESTURE_BEGAN, onZoomGesture);
			zoom.addEventListener(GestureEvent.GESTURE_CHANGED, onZoomGesture);
			target.addEventListener(Event.RESIZE, onTargetResize);
		}
		
		public function deactivate():void
		{
			if(zoom)
			{
				target.removeEventListener(Event.RESIZE, onTargetResize);
				zoom.removeEventListener(GestureEvent.GESTURE_BEGAN, onZoomGesture);
				zoom.removeEventListener(GestureEvent.GESTURE_CHANGED, onZoomGesture);
				zoom.dispose();
				zoom = null;
			}
		}
		
		protected function onZoomGesture(event:GestureEvent):void
		{
			const gesture:ZoomGesture = event.target as ZoomGesture;
			
			var mat:Matrix = target.transformationMatrix;
			var transformPoint:Point = mat.transformPoint(target.globalToLocal(zoom.location));
			mat.translate(-transformPoint.x, -transformPoint.y);
			mat.scale(gesture.scaleX, gesture.scaleY);
			mat.translate(transformPoint.x, transformPoint.y);
			target.transformationMatrix = mat;
			
			Log.traced(gesture.scaleX, gesture.scaleY, gesture.location, gesture.touchesCount);
		}
		
		private function onTargetResize(event:Event):void
		{
			target.transformationMatrix = new Matrix();
			target.x = (Common.DEFAULT_WIDTH - target.width) >> 1;
			target.y = (Common.DEFAULT_HEIGHT - target.height) >> 1;
		}
		
	}
}