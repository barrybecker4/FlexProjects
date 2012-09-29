package com.becker.animation.sprites
{
    
    import flash.geom.Point;
    
    /**
     * Represents a 2D line and common operations on it.
     * @author Barry Becker
     */
    public class Line extends AbstractShape {
        
        private var thickness:Number;
        
        /**
         * assume 0 is the starting position
         */ 
        public function Line(endPoint:Point, scale:Number, thickness:Number = 1.0, color:uint = 0xaa4400) {
            super(color)
            this.width = endPoint.x * scale;
            this.height = endPoint.y * scale;
            this.thickness = thickness;
           
            init();
        }

        private function init():void {         

            graphics.lineStyle(thickness, color);
           
            graphics.moveTo(x, y);
            var endX:int = x + Math.sqrt(width * width + height * height);
            var endY:int = y;
            graphics.lineTo(endX, endY); 
            graphics.drawCircle(endX, endY, 2);  
        }
    }
}



   