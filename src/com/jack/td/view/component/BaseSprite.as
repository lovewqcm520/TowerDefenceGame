package com.jack.td.view.component
{
	import com.jack.td.control.Global;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BaseSprite extends Sprite
	{
		protected var onClickFunc:Function;
		protected var onClickArgs:Array;

		public function BaseSprite()
		{
			
		}

		public function addChildScaled(child:DisplayObject, index:int=-1):void
		{
			if (child)
			{
				child.scaleX*=Global.contentScaleXFactor;
				child.scaleY*=Global.contentScaleYFactor;
				addChild(child);

				if(index != -1 && index < numChildren)
				{
					setChildIndex(child, index);
				}
			}
		}

		public function onClick(func:Function, ... args):void
		{
			onClickFunc=func;
			onClickArgs=args;
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		protected function onTouch(e:TouchEvent):void
		{
			var touch:Touch=e.getTouch(this);

			if (touch && touch.phase == TouchPhase.ENDED)
			{
				if (onClickFunc != null)
				{
					onClickFunc.apply(null, onClickArgs);
				}
			}
		}

		override public function dispose():void
		{
			onClickFunc=null;
			onClickArgs=null;
			
			if(hasEventListener(TouchEvent.TOUCH))
				removeEventListeners(TouchEvent.TOUCH);

			super.dispose();
		}
	}
}
