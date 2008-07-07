package  com.becker.common {
import flash.geom.Point;

    public class Util 
    {    
    	// convert from radians to degrees
        public static const RAD_TO_DEG:Number = 180.0 / Math.PI;  
           
        // convert from degrees to radians 
        public static const DEG_TO_RAD:Number = Math.PI / 180.0;      
        
        public function Util()
        {
        }
        
        
        /**
         *  @param lightness (0, 1) 0 returns dark colors, 1 light colors.
         *  @param variation (0, 1) 0 is no variation, 1 is a lot
         * @return a random RGB color
         */
        public static function getRandomColor(lightness:Number = 1.0, variation:Number = 1.0):uint
        {        
        	var base:Number = Math.max(lightness - variation/2.0, 0);
        	var vartn:Number = Math.min(variation, 1.0 - base);
            var r:uint = Math.random() * vartn * 256 + (base * 256);
            var g:uint = Math.random() * vartn * 256 + (base * 256);
            var b:uint = Math.random() * vartn * 256 + (base * 256);
            
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
        
        /**
         * Round to specificied place.
         * e.g. round(3.45, 1) = 3.5
         *      rount(23.456, 0) = 23
         *      round(12345.3, -2) = 12300
         */
        public static function round(value:Number, place:int):Number {
        	var exp:Number = Math.pow(10.0, place);
        	return Math.round(value * exp) / exp;
        }
        
        public static function distance(pt1:Point, pt2:Point):Number
        {
        	var dx:Number = pt1.x - pt2.x;
        	var dy:Number = pt1.y - pt2.y;
        	return Math.sqrt(dx * dx + dy * dy);
        }
                  
    }
}