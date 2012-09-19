package starling.extensions.tmx
{
	import de.polygonal.ds.HashMap;
	
	import flash.geom.Point;
	
	import starling.extensions.tmx.vo.LineSegment;

	public class TiledObject
	{
		public var name:String;
		public var type:String;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var gid:String;
		public var visible:Boolean;
		public var image:String;
		
		// <polygon points="0,0 206,9 -24,111 -71,75 -67,71 -67,76 -70,74"/>
		public var polygon:String;
		// <polyline points="0,0 50,92 -60,100 -50,31 -1,2"/>
		public var polyline:String;
		
		public var properties:HashMap = new HashMap();
		
		public function TiledObject()
		{
		}
		
		/**
		 * Get all the line segment that compose this object. 
		 * @return 
		 */
		public function getLineSegments():Vector.<LineSegment>
		{
			var lines:String;
			polyline ? lines = polyline : lines = polygon;
			
			if(lines)
			{
				var lineSegments:Vector.<LineSegment> = new Vector.<LineSegment>();
				// "0,0 188,448 186,536 840,570"
				var list:Array = lines.split(" ");
				var len:int = list.length;
				for (var i:int = 1; i < len; i++) 
				{
					var start:Array = list[i-1].split(",");
					var end:Array = list[i].split(",");
					var startPoint:Point = new Point(Number(start[0])+x, Number(start[1])+y);
					var endPoint:Point = new Point(Number(end[0])+x, Number(end[1])+y);	
					var lineSegment:LineSegment = new LineSegment(startPoint, endPoint);
					lineSegments.push(lineSegment);
				}
				
				return lineSegments;
			}
			
			return null;
		}
	}
}