package com.becker.common {
    
    import flash.geom.Point;
    
  
    /**
     * A set of connected segments.
     * You can add segments by specifying a new segment and a connection to another 
     * segment already in the set.
     * When removing segments, you may split this set into 2 sets.          
     *  
     * @author Barry Becker                       
     */ 
    public class Vector2d extends Point {
           
        public function Vector2d(x:Number, y:Number) {
            super(x, y);
        }
               
        /**
         * scale this vector by the specified amount.
         */
        public function scale(s:Number):void {
            x *= s;
            y *= s;
        }
        
        /**
         * make the vector have unit length.
         */
        override public function normalize(len:Number):void {
            var len:Number = this.length;
            x = (x / length) * len;
            y = (y / length) * len;
        }     
        
        /**
         * @return a new vector which is the result of adding vec to this vector.
         */
        public function plus(vec:Vector2d):Vector2d {
            return new Vector2d(x + vec.x, y + vec.y);
        }
        
        /**
         * @return a new vector which is the result of subtracting vec to this vector.
         */
        public function minus(vec:Vector2d):Vector2d {
            return new Vector2d(x - vec.x, y - vec.y);
        }
        
        /**
         * dot this vector with another.
         * The dot product is defined as
         * a.length * b*length * sin(angle between a and b)
         */
        public function dot(vec:Vector2d):Number {
            return x * vec.x + y * vec.y;
        }
        
        /**
         * cross this vector with another.
         * http://en.wikipedia.org/wiki/Cross_product
         * @return a scalar that should be multipliec by the unit vector 
         * perpendicular to the 2 that we are crossing.
         */
        public function cross(vec:Vector2d):Number {
            return x * vec.y - y * vec.x;
        }      
               
        override public function toString():String {           
            return "("+ x + ", " +y +")";           
        }
    }
}