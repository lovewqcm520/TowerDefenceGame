package
{
	import com.jack.td.Game;
	import com.jack.td.control.Common;
	import com.jack.td.control.Global;
	import com.jack.td.control.util.Assets;
	import com.jack.td.log.Log;
	import com.jack.td.view.screen.Splash;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.gestouch.core.Gestouch;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.input.NativeInputAdapter;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	[SWF(width="960", height="640", frameRate="30", backgroundColor="#ffffff")]
	public class TowerDefenceGame extends Sprite
	{
		public function TowerDefenceGame()
		{
			if(this.stage)
				init();
			else
				addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:flash.events.Event=null):void
		{
			// show the splash view first
			var splash:Splash=new Splash(Assets.getBitmap("asset_bg_splash"), Game.getInstance().showGame, 3000, Splash.SCALE_MODE_STRETCH);
			stage.addChild(splash);
			
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);
			
			// do not support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var viewPort:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			
			Starling.handleLostContext = false;
			Starling.multitouchEnabled = true;
			
			var mStarling:Starling = new Starling(Startup, stage, viewPort, null, "auto", "baseline");
			mStarling.enableErrorChecking = true;
			mStarling.showStats = true;
			
			mStarling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onContextCreated);
			mStarling.start();
			
			// get the screen scale factor
			Common.FULLSCREEN_WIDTH = stage.fullScreenWidth;
			Common.FULLSCREEN_HEIGHT = stage.fullScreenHeight;
			Global.contentScaleXFactor=stage.fullScreenWidth / Common.DEFAULT_WIDTH;
			Global.contentScaleYFactor=stage.fullScreenHeight / Common.DEFAULT_HEIGHT;
			
			// init the Gestouch Framework
			/* setup & start your Starling instance here */
			// Gestouch initialization step 1 of 3:
			
			// Initialize native (default) input adapter. Needed for non-DisplayList usage.
			
			Gestouch.inputAdapter ||= new NativeInputAdapter(stage);
			
			
			// Gestouch initialization step 2 of 3:
			
			// Register instance of StarlingDisplayListAdapter to be used for objects of type starling.display.DisplayObject.
			
			// What it does: helps to build hierarchy (chain of parents) for any Starling display object and
			
			// acts as a adapter for gesture target to provide strong-typed access to methods like globalToLocal() and contains().
			
			Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());
			
			
			// Gestouch initialization step 3 of 3:
			
			// Initialize and register StarlingTouchHitTester.
			
			// What it does: finds appropriate target for the new touches (uses Starling Stage#hitTest() method)
			
			// What does “-1” mean: priority for this hit-tester. Since Stage3D layer sits behind native DisplayList
			
			// we give it lower priority in the sense of interactivity.
			
			Gestouch.addTouchHitTester(new StarlingTouchHitTester(mStarling), -1);
			
			// NB! Use Gestouch#removeTouchHitTester() method if you manage multiple Starling instances during
			
			// your application lifetime.
		}
		
		private function onContextCreated(e:starling.events.Event):void
		{
			// initialize the game.
			Game.getInstance().initialize();
			
			Log.traced("onContextCreated", Starling.current.stage.stageWidth, Starling.current.stage.stageHeight,
				Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight);
		}
	}
}