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
     * 
     *            x,y
     *         /   _____________________
     * height {   < o                 o >  rear
     *         \   ---------------------
     *        front       width               
     *                         
     */ 
    public class Segment extends Sprite
    {
        private static const DEFAULT_PIN_RADIUS:Number = 2.0;
        
        public var id:String;
        
        // velocity vector
        public var vx:Number = 0;
        public var vy:Number = 0;
        
        private var color:uint;
        private var segmentWidth:Number;
        private var segmentHeight:Number;    
        
        // child connections
        private var frontConnections:Array;
        private var rearConnections:Array;
        
        
        public function Segment(segmentWidth:Number, segmentHeight:Number, 
                                id:String = null, color:uint = 0xffffff)
        {
            this.segmentWidth = segmentWidth;
            this.segmentHeight = segmentHeight;
            this.color = color;
            this.frontConnections = new Array();
            this.rearConnections = new Array();
            this.id = id;
            init();
        }
        
        public function init():void
        {
            // draw the segment itself
            graphics.lineStyle(0);
            graphics.beginFill(color);
            graphics.drawRoundRect(-segmentHeight / 2, 
                                   -segmentHeight / 2,
                                   segmentWidth + segmentHeight,
                                   segmentHeight,
                                   segmentHeight,
                                   segmentHeight);
            graphics.endFill();
            
            // draw the two "pins"
            graphics.drawCircle(0, 0, DEFAULT_PIN_RADIUS);
            graphics.drawCircle(segmentWidth, 0, DEFAULT_PIN_RADIUS);
        }
        
        /**
         * On the left when oriented normally
         */
        public function getFrontPin():Point
        {
            return new Point(x, y);
        }
        
        /**
         * On the right when oriented normally
         */
        public function getRearPin():Point
        {
            var angle:Number = rotation * Math.PI / 180;
            var xPos:Number = x + Math.cos(angle) * segmentWidth;
            var yPos:Number = y + Math.sin(angle) * segmentWidth;
            return new Point(xPos, yPos);
        }
        
        /**
         * connect this segment with another.
         * @param segment segment to connect to
         * @param front if the segment is connecting to our front.
         * @param toFront we are connecting to its front.
         */         
        public function connect(segment:Segment, front:Boolean, toFront:Boolean):void
        {
            if (front) {
                frontConnections.push(segment);
            } else {
                rearConnections.push(segment);
            }
            if (toFront) {
                segment.frontConnections.push(this);
            } else {
                segment.rearConnections.push(this);
            }                        
        }
        
        /**
         * Recusively drag all child semgents.
         */
        public function dragChildSegments(parentSegment:Segment, xpos:Number, ypos:Number):void
        {
             dragFromRear(xpos, ypos);
             dragChildSegments1(frontConnections, parentSegment, x, y);
             var rearPin:Point = getRearPin();
             //dragFromRear(xpos, ypos);
             //dragChildSegments1(rearConnections, parentSegment, rearPin.x, rearPin.y);             
        }
        
        private function dragChildSegments1(connections:Array, 
                              parentSegment:Segment, xpos:Number, ypos:Number):void
        {
            for each (var s:Segment in connections)
            {
                if (s != parentSegment)
                {
                    //trace("dragging child="+ this + " to "+ xpos+ ","+ypos);
                    s.dragChildSegments(this, xpos, ypos);
                }
            }
        }
        
        /**
         *  move the rear of the segment toward xpos, ypos
         */
        public function dragFromRear(xpos:Number, ypos:Number):void
        {                
            var frontPin:Point = getFrontPin();            
            var dx:Number = xpos - frontPin.x;
            var dy:Number = ypos - frontPin.y;
            var angle:Number = Math.atan2(dy, dx);
            rotation = angle * 180 / Math.PI;
            
            var rearPin:Point = getRearPin();
            var w:Number = rearPin.x - x;
            var h:Number = rearPin.y - y;
            x = xpos - w;
            y = ypos - h;            
        }
        
        /**
         *  move the rear of the segment toward xpos, ypos
         */
        public function dragFromFront(xpos:Number, ypos:Number):void
        {
            var rearPin:Point = getRearPin();    
            var dx:Number = xpos - rearPin.x;
            var dy:Number = ypos - rearPin.y;
            var angle:Number = Math.atan2(dy, dx);
            rotation = angle * 180 / Math.PI;
            
            //rearPin:Point = getRearPin();        
            //var w:Number = rearPin.x - x;
            //var h:Number = rearPin.y - y;
            x = xpos;
            y = ypos;
        }
        
        /*
        private function drag(startPin:Point, otherPin:Point, 
                              xpos:Number, ypos:Number):void
        {                
            var dx:Number = xpos - startPin.x;
            var dy:Number = ypos - startPin.y;
            var angle:Number = Math.atan2(dy, dx);
            rotation = angle * 180 / Math.PI;
                    
            var w:Number = otherPin.x - x;
            var h:Number = otherPin.y - y;
            x = xpos - w;
            y = ypos - h;
        }*/
        
        override public function toString():String
        {
            return "Segment "+id+": x="+x+" y="+y+" connections: " + 
                    "numFront="+frontConnections.length +
                    " numRear=" + rearConnections.length;
        }
    }
}