package com.jack.td.view.component
{
	import com.jack.llk.Game;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.factors.GameStatusFactors;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	
	import flash.utils.getTimer;
	
	import org.josht.starling.foxhole.controls.ProgressBar;
	import org.josht.starling.foxhole.extensions.MyProgressBar;
	import org.josht.starling.motion.GTween;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.extensions.MyMovieClip;
	import starling.display.Sprite;

	public class CountDownSprite extends Sprite
	{
		private var totalTime:int;
		private var warningStartTime:int;
		private var warningPercentage:Number;
		private var isWarningActivate:Boolean;
		private var tmpGetTime:Number=0;
		private var progressWidth:Number;
		private var _usedTime:Number;
		private var tempTime:Number;

		private var progress:MyProgressBar;
		private var pTween:GTween;
		private var mcMovingIcon:MyMovieClip;
		private var regularBgSkin:Image;
		private var warningBgSkin:Image;
		private var onFinishFunc:Function;

		public function CountDownSprite(totalTime:int, warningStartTime:int)
		{
			super();

			this.totalTime=totalTime;
			this.warningStartTime=warningStartTime;
			warningPercentage=warningStartTime / totalTime;
			isWarningActivate=false;
			init();
		}

		public function set onFinished(onFinishFunc:Function):void
		{
			this.onFinishFunc=onFinishFunc;
		}

		private function init():void
		{
			// set the moving icon
			mcMovingIcon=Assets.getMovieClip("BIG_ITEM_15");
			mcMovingIcon.loop=true;

			regularBgSkin=Assets.getImage("ratebg");
			warningBgSkin=Assets.getImage("ratelessbg");
			progressWidth=regularBgSkin.width;

			// init the progress
			progress=new MyProgressBar();
			progress.onProgress=onProgress;
			progress.onFinish=onFinish;
			progress.minimum=0;
			progress.maximum=1;
			progress.value=0;
			addChild(progress);
			progress.direction=ProgressBar.DIRECTION_HORIZONTAL;
			// set background image and fill image
			progress.backgroundSkin=regularBgSkin;
			var fill:Image=Assets.getImage("rateoverbg");
			fill.width=0;
			fill.height=0;
			progress.fillSkin=fill;

			// set the tween for progress
			pTween=new GTween(progress, totalTime, {value: 1}, {repeatCount: 1});

			// set moving character position
			mcMovingIcon.pivotX=mcMovingIcon.width / 2;
			mcMovingIcon.pivotY=mcMovingIcon.height / 2;
			mcMovingIcon.x=0;
			mcMovingIcon.y=regularBgSkin.height / 2;
			addChild(mcMovingIcon);
			Starling.juggler.add(mcMovingIcon);
			
			_usedTime = 0;
			tempTime = getTimer();
		}

		public function reset(totalTime:int, warningStartTime:int):void
		{
			this.totalTime=totalTime;
			this.warningStartTime=warningStartTime;
			_usedTime=0;
			warningPercentage=warningStartTime / totalTime;
			isWarningActivate=false;

			progress.value=0;
			progress.backgroundSkin=regularBgSkin;

			pTween.beginning();
			pTween.duration=totalTime;
			pTween.paused=false;
			
			tempTime = getTimer();
		}
		
		public function updateCurTime(t:int):void
		{
			progress.value = t/totalTime;
			isWarningActivate = (progress.value >= warningPercentage);
			isWarningActivate ? progress.backgroundSkin=warningBgSkin : progress.backgroundSkin=regularBgSkin;
			
			// restart at the last position
			pTween.position = t;
			pTween.paused = true;
			pTween.paused=false;
			
			_usedTime += (getTimer()-tempTime);
			tempTime = getTimer();
		}

		private function onProgress():void
		{
			// update the moving character position
			var tmpX:Number=progressWidth * progress.value;
			mcMovingIcon.x=tmpX;

			// do warning stuff
			if (progress.value >= warningPercentage)
			{
				var tmp:Number=getTimer();

				if (!isWarningActivate)
				{
					// set game status to warning status
					Game.getInstance().gameStatus=GameStatusFactors.STATUS_WARNING;

					// play warning sound
					SoundManager.play(SoundFactors.DAO_JI_SHI_MUSIC, false, true);
				}

				// shine the remain time progress bar to make it obvious
				// control time to switch progress backgroundSkin 150ms once
				if (tmp - tmpGetTime >= 150)
				{
					if (progress.backgroundSkin == regularBgSkin)
						progress.backgroundSkin=warningBgSkin;
					else
						progress.backgroundSkin=regularBgSkin;

					tmpGetTime=tmp;
				}

				// update the flag
				isWarningActivate=true;
			}
		}

		private function onFinish():void
		{
			// stop warning sound
			SoundManager.stop(SoundFactors.DAO_JI_SHI_MUSIC);
			// stop moving
			mcMovingIcon.stop();

			// call the function 
			if (onFinishFunc != null)
			{
				onFinishFunc.apply();
			}
			
			_usedTime += (getTimer()-tempTime);
			tempTime = getTimer();
		}


		/**
		 * Resume the count down.
		 */
		public function resume():void
		{
			if (pTween)
			{
				pTween.paused=false;
			}

			// play warning sound
			if (isWarningActivate)
			{
				SoundManager.play(SoundFactors.DAO_JI_SHI_MUSIC, false, true);
			}
			
			tempTime = getTimer();
		}

		public function get currentTime():int
		{
			return pTween.position;
		}

		/**
		 * Pause the count down.
		 */
		public function pause():void
		{
			if (pTween)
			{
				pTween.paused=true;
			}

			// stop warning sound
			SoundManager.stop(SoundFactors.DAO_JI_SHI_MUSIC);
			
			_usedTime += (getTimer()-tempTime);
			tempTime = getTimer();
		}

		override public function dispose():void
		{
			regularBgSkin=null;
			warningBgSkin=null;
			
			if(pTween)
			{
				Starling.juggler.remove(pTween);
				pTween.paused=true;
				pTween=null;
			}
			
			super.dispose();
		}

		public function get usedTime():int
		{
			return Math.round(_usedTime/1000);
		}

	}
}
