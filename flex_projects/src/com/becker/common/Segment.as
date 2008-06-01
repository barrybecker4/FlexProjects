package com.becker.common
{
    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * A simple segment that can be combined with other segments
     * to produce kinematic simulations.
     * 
     * This diagram represents the segments parts:
     * 
     *            x,y
     *         /   _____________________
     * height {   < o                 o >  rear connector
     *         \   ---------------------
     *      front con.     width               
     *                         
     */ 
    public class Segment extends Sprite
    {
        // don't necessarily allow a joint to fold back on itselt.
        private static const DEFAULT_ANGLE_LIMIT:Number = 0.7; 
        
        private var color_:uint;
        private var length_:Number;
        private var thickness_:Number;    
        
        // child connections
        public var frontConnector:Connector;
        public var rearConnector:Connector;
        
        // velocity vector
        public var vx:Number = 0;
        public var vy:Number = 0;
        
        private var angleLimit:Number = DEFAULT_ANGLE_LIMIT;
        
        public function Segment(length:Number, thickness:Number, 
                                color:uint = 0xffffff)
        {
            length_ = length;
            thickness_ = thickness;
            color_ = color;
            frontConnector = new Connector(this, true);
            rearConnector = new Connector(this, false);  
            addChild(frontConnector); 
            addChild(rearConnector);   
            init();
        }
        
        public function init():void
        {
            // draw the segment itself
            graphics.lineStyle(0);
            graphics.beginFill(color_);
            graphics.drawRoundRect(-thickness / 2, 
                                   -thickness / 2,
                                   length + thickness,
                                   thickness,
                                   thickness,
                                   thickness);
            graphics.endFill();
        }
        
        public function get length():Number {
            return length_;
        }
        public function get thickness():Number {
            return thickness_;
        }
        
        /*
        private function jointAngle(seg:Segment):Number
        {
        	var vec1:Point = getFrontPin().subtract(getRearPin());
        	vec1.normalize(1.0);
        	var vec2:Point = seg.getFrontPin().subtract(seg.getRearPin());
        	vec2.normalize(1.0);
        	return Math.acos(vec1.x * vec2.x + vec1.y * vec2.y);
        }*/
        
        
        /**
         * @return true if specified x, y closer to front than rear.
         */
        public function closerToFront(x:Number, y:Number):Boolean
        {
        	var pt:Point = new Point(x, y);
        	var distToFront:Number = Point.distance(frontConnector.getPosition(), pt);
        	var distToRear:Number = Point.distance(rearConnector.getPosition(), pt);
        	return (distToFront < distToRear);
        }
        
        override public function toString():String
        {
            return "Segment x="+x+" y="+y+" connections: " + 
                    "frontConnector="+ frontConnector+
                    " rearConnector=" + rearConnector;
        }
    }
}