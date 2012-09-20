package starling.extensions.tmx
{
	import de.polygonal.ds.HashMap;

	public class TiledObjectGroup
	{
		public var name:String;
		public var color:String;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var opacity:Number;
		public var visible:Boolean;
		
		public var properties:HashMap = new HashMap();
		public var tiledObjects:Vector.<TiledObject> = new Vector.<TiledObject>();
		
		public function TiledObjectGroup()
		{
			opacity = 1;
			visible = true;
		}
	}
}