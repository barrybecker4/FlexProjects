package  com.becker.common {
import flash.geom.Point;

	public class Util 
	{	
		
		public function Util()
		{
		}
		
		
		/**
		 * return a random RGB color
		 */
		public static function getRandomColor():uint
		{		
			var r:uint = Math.random() * 256;
			var g:uint = Math.random() * 256;
			var b:uint = Math.random() * 256;
			
			return 0x010000 * r + 0x000100 * g + b;
		}	
		
		/**
		 * Rotate a point
		 */
		public static function rotate(x:Number,
							          y:Number,
								      sin:Number,
							          cos:Number,
								      reverse:Boolean):Point
		{
			var result:Point = new Point();
			if(reverse)
			{
				result.x = x * cos + y * sin;
				result.y = y * cos - x * sin;
			}
			else
			{
				result.x = x * cos - y * sin;
				result.y = y * cos + x * sin;
			}
			return result;
		}				
	}
}