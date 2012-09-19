package starling.extensions.tmx.vo
{
	import com.jack.td.util.MathUtil;
	
	import flash.geom.Point;

	public class LineSegment
	{
		public var start:Point;
		public var end:Point;
		public var radian:Number;
		public var angle:Number;
		public var isVertical:Boolean;
		public var isHorizontal:Boolean;
		public var length:Number;
		
		// y=kx+b
		public var k:Number=NaN;
		public var b:Number=NaN;
		
		public function LineSegment(start:Point, end:Point)
		{
			this.start = start;
			this.end = end;
			
			length = Math.sqrt((start.x-end.x)*(start.x-end.x) + (start.y-end.y)*(start.y-end.y))
			radian = MathUtil.getLineSlopeRadian(start, end);
			angle =  MathUtil.rad2Angle(radian);
			isVertical = (radian == MathUtil.RADIAN_90);
			isHorizontal = (radian == MathUtil.RADIAN_0);
			
			if(!isVertical)
			{
				k = (end.y-start.y)/(end.x-start.x);
				b = 0.5 * ((start.y + end.y) - k*(start.x + end.x));
			}
			
			trace("angle", angle);
		}
	}
}