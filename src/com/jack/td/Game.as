package com.jack.td
{
	import com.jack.td.control.Common;
	import com.jack.td.control.factors.FramerateFactors;
	import com.jack.td.control.factors.GameStatusFactors;
	import com.jack.td.control.gesture.PanGestureController;
	import com.jack.td.control.util.Assets;
	import com.jack.td.log.Log;
	import com.jack.td.view.Battle;
	import com.jack.td.view.component.BaseSprite;
	import com.jack.td.view.enemy.Enemy;
	import com.jack.td.view.screen.TiledMap;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.flash_proxy;
	
	import starling.core.Starling;

	public class Game
	{
		private static var _instance:Game=new Game();

		public var container:BaseSprite;
		private var _gameStatus:int;
		public var gameModel:int;
		private var _mInitialed:Boolean=false;


		private var oldTime:Number;

		public var battle:Battle;
 
		public function Game()
		{
		}

		public static function getInstance():Game
		{
			return _instance;
		}

		public function initialize():void
		{
			if(!_mInitialed)
			{
				_mInitialed = true;
				
				Assets.init();
				
				container=new BaseSprite();
				Starling.current.stage.addChildAt(container, 0);
				
				initGame();
				
				// add stage keyboard event
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				
				// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
				// would report a very long 'passedTime' when the app is reactivated.			
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
				NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
				
				// add enter_frame event
				Starling.current.nativeStage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				// 
				Starling.current.showStats = true;
			}
		}
		
		protected function onExit(event:Event):void
		{
		}
		
		private function initGame():void
		{
			// load assets
			// init some ui

			// read setting config from local shared object
			
			// testonly
			battle = new Battle();
			container.addChildScaled(battle);
		}

		public function showGame():void
		{
			// play the waiting background music
			//SoundManager.play(SoundFactors.DATING_BACK_MUSIC, true, true);
			gameStatus = GameStatusFactors.STATUS_IDLE;
		}

		/**
		 * Mobile status change to deactivate.
		 * @param event
		 */
		protected function onDeactivate(event:Event):void
		{
			Log.log("onDeactivate");
			
			// update the framerate
			//Starling.current.stop();
			//Starling.current.nativeStage.frameRate=FramerateFactors.FPS_DEACTIVATE;

		}

		/**
		 * Mobile status change to activate.
		 * @param event
		 */
		protected function onActivate(event:Event):void
		{
			Log.log("onActivate");
			// update the framerate
			Starling.current.start();
			// 针对不同的游戏状态更新不同的framerate
			switch (gameStatus)
			{
				case GameStatusFactors.STATUS_IDLE:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_IDLE;
					break;
				}

				case GameStatusFactors.STATUS_PAUSE_BY_DEACTIVATE:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PAUSE_BY_DEACTIVATE;
					break;
				}

				case GameStatusFactors.STATUS_PAUSE_BY_USER:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PAUSE_BY_USER;
					break;
				}

				case GameStatusFactors.STATUS_PLAYING:
				{
					break;
				}

				case GameStatusFactors.STATUS_WARNING:
				{
					break;
				}

				case GameStatusFactors.STATUS_OVER:
				{
					break;
				}

				case GameStatusFactors.STATUS_START:
				{
					break;
				}

				default:
				{
					Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;
				}
			}

		}

		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.BACK:
				{
					// prevent the default event behavior
					//event.preventDefault();
					NativeApplication.nativeApplication.exit();

					break;
				}
			}
		}

		protected function onEnterFrame(event:Event):void
		{
		}

		public function get gameStatus():int
		{
			return _gameStatus;
		}

		public function set gameStatus(value:int):void
		{
			if(_gameStatus != value)
			{
				_gameStatus = value;
				
				// 针对不同的游戏状态更新不同的framerate
				switch (gameStatus)
				{
					case GameStatusFactors.STATUS_IDLE:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_IDLE;
						// resume play warning sound
						break;
					}
						
					case GameStatusFactors.STATUS_PAUSE_BY_DEACTIVATE:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PAUSE_BY_DEACTIVATE;
						break;
					}
						
					case GameStatusFactors.STATUS_PAUSE_BY_USER:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PAUSE_BY_USER;
						break;
					}
						
					case GameStatusFactors.STATUS_PLAYING:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;
						break;
					}
						
					case GameStatusFactors.STATUS_WARNING:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;
						
						break;
					}
						
					case GameStatusFactors.STATUS_OVER:
					{
						break;
					}
						
					case GameStatusFactors.STATUS_START:
					{
						break;
					}
						
					default:
					{
						Starling.current.nativeStage.frameRate=FramerateFactors.FPS_PLAYING;
					}
				}
			}
		}

	}
}
