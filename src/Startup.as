package
{
	import com.jack.td.Game;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class Startup extends Sprite
	{
		public function Startup()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			initialize();
		}

		private function initialize():void
		{

		}

	}
}
