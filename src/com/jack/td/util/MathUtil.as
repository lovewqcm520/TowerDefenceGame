package com.jack.td.util
{
	import flash.geom.Point;
	
	import starling.extensions.tmx.vo.LineSegment;

	public class MathUtil
	{
		public static const RADIAN_90:Number = 90*Math.PI/180;
		public static const RADIAN_0:Number = 0;
		
		private static const RAD2ANG:Number = 180/Math.PI;
		private static const ANG2RAD:Number = Math.PI/180;
		
		public static function isOnLine(x:Number, y:Number, line:LineSegment, deviation:Number=5):Boolean
		{
			var x1:Number = line.start.x;
			var x2:Number = line.end.x;
			var x0:Number = x;
			
			var y1:Number = line.start.y;
			var y2:Number = line.end.y;
			var y0:Number = y;
			
			var minX:Number = Math.min(x1, x2);
			var maxX:Number = Math.max(x1, x2);
			var minY:Number = Math.min(y1, y2);
			var maxY:Number = Math.max(y1, y2);
			
			if(x0-minX >= -1 && x0-maxX <= 1 && y0-minY >= -1 && y0-maxY<= 1)
			{
				var d:Number = point2Line(x0, y0, x1, y1, x2, y2);
				//trace(x0, y0, d);
				return d <= deviation;
			}
			
			return false;
		}
		
		/**
		 * 根据弧度得到角度
		 * @param rad
		 * @return 
		 */
		public static function rad2Angle(rad:Number):Number
		{
			return rad * RAD2ANG
		}
		
		/**
		 * 根据角度得到弧度
		 * @param ang
		 * @return 
		 */
		public static function ang2Radian(ang:Number):Number
		{
			return ang * ANG2RAD
		}
		
		/**
		 * 计算点(x0, y0)到由两点(x1, y1), (x2, y2)组成的直线的距离。
		 * @param x0
		 * @param y0
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 */
		public static function point2Line(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var a:Number = y2 - y1;
			var b:Number = x1 - x2;
			var c:Number = x2*y1 - x1*y2;
			var dis:Number = Math.abs(a*x0 + b*y0 + c) / Math.sqrt(a*a + b*b);
			
			return dis;
		}
		
		public static function point2Point(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			return Math.sqrt((x0-x1)*(x0-x1) + (y0-y1)*(y0-y1));
		}
		
		/**
		 * 已知一点以及圆的圆心坐标和半径，判断该点是否在圆内。
		 * (通过判断点到圆心的距离是否大于圆的半径判断该点是否在圆内)
		 * @param px		点的横坐标
		 * @param py		点的纵坐标
		 * @param ccx		圆心的横坐标
		 * @param ccy		圆心的纵坐标
		 * @param radius	圆的半径
		 * @return 
		 */
		public static function pointInCircle(px:Number, py:Number, ccx:Number, ccy:Number, radius:Number):Boolean
		{
			return (ccx-px)*(ccx-px) + (ccy-py)*(ccy-py) <= radius*radius;
		}
		
		/**
		 * 通过直线上的两点得到直线的倾斜弧度（基于斜率）。
		 * 
		 * 斜率，亦称“角系数”，表示一条直线相对于横坐标轴的倾斜程度。
		 * 一条直线与某平面直角坐标系横坐标轴正半轴方向的夹角的正切值即该直线相对于该坐标系的斜率。 
		 * 如果直线与x轴互相垂直，直角的正切值无穷大，故此直线，不存在斜率。 当直线L的斜率存在时，对于一次函数y=kx+b，
		 * （斜截式）k即该函数图像的斜率。
		 * @param p1
		 * @param p2
		 * @return 
		 */
		public static function getLineSlopeRadian(p1:Point, p2:Point):Number
		{
			var radian:Number;
			
			if(p1.x == p2.x)
				radian = RADIAN_90;
			else
			{
				if(p1.y == p2.y)
					radian = RADIAN_0;
				else
				{
					var slope:Number = Math.abs((p2.y-p1.y)/(p2.x-p1.x));
					radian = Math.atan(slope);
				}
			}
			
			return radian;
		}
		
		/**
		 * 通过直线上的两点得到直线的倾斜角度（基于斜率）。
		 * 
		 * 斜率，亦称“角系数”，表示一条直线相对于横坐标轴的倾斜程度。
		 * 一条直线与某平面直角坐标系横坐标轴正半轴方向的夹角的正切值即该直线相对于该坐标系的斜率。 
		 * 如果直线与x轴互相垂直，直角的正切值无穷大，故此直线，不存在斜率。 当直线L的斜率存在时，对于一次函数y=kx+b，
		 * （斜截式）k即该函数图像的斜率。
		 * @param p1
		 * @param p2
		 * @return 
		 */
		public static function getLineSlopeAngle(p1:Point, p2:Point):Number
		{
			var angle:Number;
			
			if(p1.x == p2.x)
				angle = 90;
			else
			{
				if(p1.y == p2.y)
					angle = 0;
				else
				{
					var slope:Number = Math.abs((p2.y-p1.y)/(p2.x-p1.x));
					angle = Math.atan(slope)*RAD2ANG;
				}
			}
			
			return angle;
		}
	}
}