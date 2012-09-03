package com.becker.animation.sprites
{
    
    import flash.geom.Point;
    
    /**
     * Represents a 2D line and common operations on it.
     * @author Barry Becker
     */
    public class Line extends AbstractShape
    {
        private var thickness:Number;
        private var startPoint:Point;
        private var endPoint:Point;
        
        public function Line(startPoint:Point, endPoint:Point, thickness:Number = 2.0, color:uint = 0xff2200)
        {
            super(color)
            this.width = width;
            this.height = height;
            this.thickness = thickness;
            
            this.startPoint = startPoint;
            this.endPoint = endPoint;
            
            init();
        }

        private function init():void
        {         

            graphics.lineStyle(thickness, color);
           
            graphics.moveTo(startPoint.x, startPoint.y);
            graphics.lineTo(endPoint.x, endPoint.y); 
            graphics.drawCircle(endPoint.x, endPoint.y, 4);         
            
        }
    }
}



   