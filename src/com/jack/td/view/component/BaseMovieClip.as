package com.jack.td.view.component
{
	import starling.extensions.MyMovieClip;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class BaseMovieClip extends MyMovieClip
	{
		private var onClickFunc:Function;

		public function BaseMovieClip(textures:Vector.<Texture>, fps:Number=12)
		{
			super(textures, fps);

			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		public function resetTextures(textures:Vector.<Texture>, fps:Number=12)
		{
			if (textures.length > 0)
			{
				super(textures[0]);
				init(textures, fps);
			}
			else
			{
				throw new ArgumentError("Empty texture array");
			}
		}
		
		public function set onClick(func:Function):void
		{
			onClickFunc=func;
		}

		protected function onTouch(event:TouchEvent):void
		{
			var touch:Touch=event.getTouch(this);

			if (touch)
			{
				if (touch.phase == TouchPhase.ENDED)
				{
					if (onClickFunc != null)
						onClickFunc.apply();
				}
			}
		}

		override public function dispose():void
		{
			onClickFunc=null;
			removeEventListener(TouchEvent.TOUCH, onTouch);

			super.dispose();
		}
	}
}
