package  com.becker.common {
    
import Box2D.Common.Math.b2Vec2;
import flash.geom.Point;

    public class Util  {    
        /** convert from radians to degrees */
        public static const RAD_TO_DEG:Number = 180.0 / Math.PI;  
           
        /** convert from degrees to radians */
        public static const DEG_TO_RAD:Number = Math.PI / 180.0; 
        
        private static const LN10:Number = Math.log(10.0);
        
        /** private constructor for static util class */
        //private function Util() {}
        
        
        /**
         * @param lightness (0, 1) 0 returns dark colors, 1 light colors.
         * @param variation (0, 1) 0 is no variation, 1 is a lot
         * @return a random RGB color
         */
        public static function getRandomColor(lightness:Number = 1.0, variation:Number = 1.0):uint {        
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
        public static function rotate(
            x:Number,  y:Number, sin:Number,  cos:Number, reverse:Boolean):Point
        {
            var result:Point = new Point();
            if (reverse) {
                result.x = x * cos + y * sin;
                result.y = y * cos - x * sin;
            }
            else {
                result.x = x * cos - y * sin;
                result.y = y * cos + x * sin;
            }
            return result;
        }   
        
        /**
         * @param v
         * @return Log base 10 of v.
         */
        public static function log10(v:Number):Number {
            return Math.log(v) / LN10;
        }
        
        /**
         * @return th greatest common factor of a and b
         */
        public static function greatestCommonFactor(a:int, b:int):int {
            if (a == 0 && b == 0) return 1;
            if (a < 0) return greatestCommonFactor(-a, b);
            if (b < 0) return greatestCommonFactor(a, -b);
            if (a == 0) return b;
            if (b == 0) return a;
            if (a == b) return a;
            if (b < a) return greatestCommonFactor(b, a);

            return greatestCommonFactor(a, b % a);
        }

        /**
         * @return the least common multiple of a and b
         */
        public static function leastCommonMultiple(a:int, b:int):int {
            return Math.abs(a * b) / greatestCommonFactor(a, b);
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
        
        public static function distance(pt1:Point, pt2:Point):Number {
            var dx:Number = pt1.x - pt2.x;
            var dy:Number = pt1.y - pt2.y;
            return Math.sqrt(dx * dx + dy * dy);
        }
        
         /**
         * First, arrange all given points in ascending order, according to their x-coordinate.
         * Second, take the leftmost and rightmost points (lets call them C and D), and creates tempVec, 
         * where the points arranged in clockwise order will be stored.
         * Then, it iterates over the vertices vector, and uses the det() method. 
         * It starts putting the points above CD from the beginning of the vector, 
         * and the points below CD from the end of the vector. 
         */
         public static function arrangeClockwise(vec:Array):Array {
            
            var n:int = vec.length;
            var d:Number; 
            var i1:int = 1;
            var i2:int = n - 1;
            var tempVec:Array = new Array(n), C:b2Vec2, D:b2Vec2;
            
            vec.sort(comparator);
            tempVec[0] = vec[0];
            C = vec[0];
            D = vec[n-1];
            for (var i:Number=1; i<n-1; i++) {
                d = determinate(C, D, vec[i]);
                if (d < 0) {
                    tempVec[i1++] = vec[i];
                }
                else {
                    tempVec[i2--] = vec[i];
                }
            }
            tempVec[i1] = vec[n-1];
            return tempVec;
        }
        
        /**
         * This is a compare function, used in the arrangeClockwise() method 
         * - a fast way to arrange the points in ascending order, according to their x-coordinate.
         * @return 1 of x coordinate of a greater than x coordinate of b; -1 of less; 0 if equal.
         */
        private static function comparator(a:b2Vec2, b:b2Vec2):Number {
            if (a.x > b.x) {
                return 1;
            }
            else if (a.x < b.x) {
                return -1;
            }
            return 0;
        }
        
        /**
         * Finds the determinant of a 3x3 matrix. 
         * Returns a positive number if the three given points are in clockwise order, 
         * negative if they are in anti-clockwise order and zero if they lie on the same line.
         * Another useful thing about determinants is that their absolute value is two times the face of the 
         * triangle, formed by the three given points.
         * 
         * @return the determinant
         */
        public static function determinate(p1:b2Vec2, p2:b2Vec2, p3:b2Vec2):Number {
            return p1.x * p2.y + p2.x * p3.y + p3.x * p1.y - p1.y * p2.x - p2.y * p3.x - p3.y * p1.x;
        }
        
        /** 
         * function to get the area of a shape. Tiny shapes will be removed to increase performance. 
         * @param vertices vertices of a polygonal shape
         * @return area of the polygon.
         */
        public static function findArea(vertices:Array):Number {
 
            var count:uint = vertices.length;
            var area:Number = 0.0;
            var p1X:Number = 0.0;
            var p1Y:Number = 0.0;
            var inv3:Number = 1.0 / 3.0;
            
            for (var i:int = 0; i < count; ++i) {
                var p2:b2Vec2 = vertices[i];
                var p3:b2Vec2 = (i + 1 < count) ? vertices[int(i+1)] : vertices[0];
                var e1X:Number = p2.x - p1X;
                var e1Y:Number = p2.y - p1Y;
                var e2X:Number = p3.x - p1X;
                var e2Y:Number = p3.y - p1Y;
                var D:Number = (e1X * e2Y - e1Y * e2X);
                var triangleArea:Number = 0.5 * D;
                area += triangleArea;
            }
            return area;
        } 
    }
}