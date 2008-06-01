package com.becker.common
{
    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * Represents a connection between segments.
     *          
     * @author Barry Becker                       
     */ 
    public class Connector extends Sprite
    {
        // the segment that owns this connector (and one other)
        private var owner_:Segment;
        
        private var isFront_:Boolean;
        
        // other segment connectors that we are connected to.
        private var connections:Array;
        
        // velocity vector
        public var vx:Number = 0;
        public var vy:Number = 0;
        
        private var radius:Number;
        private var color:uint;
        
        public function Connector(owner:Segment, isFront:Boolean, color:uint = 0xffee00)                                 
        {
        	this.owner_ = owner;
        	this.isFront_ = isFront;
            this.radius = owner.thickness/2.0 - 2;  
            connections = new Array();
            this.color = color;
            init();
        }
        
        public function get owner():Segment {
        	return owner_;
        }
        
        public function get isFront():Boolean {
        	return isFront_;
        }
        
        public function init():void
        {          
        	graphics.lineStyle(0);
        	if (isFront) {
        		color = 0x1111ee;
        	}
        	graphics.beginFill(color);
            graphics.drawCircle(isFront?0:owner.length, 0, radius);  
            graphics.endFill();
        }        
      
        /**
         * On the left or right of the owning segment.
         */
        public function getPosition():Point
        {      	
        	if (isFront_) {
                return new Point(owner_.x, owner_.y);
            } else {
            	var angle:Number = Util.DEG_TO_RAD * owner_.rotation;
	            var xpos:Number = owner_.x + Math.cos(angle) * owner_.length;
	            var ypos:Number  = owner_.y + Math.sin(angle) * owner_.length;
	            return new Point(xpos, ypos);
            }         
        }
        
        
        /**
         * connect this segment with another.
         * @param connector to connect to
         */         
        public function connect(connector:Connector):void
        {           
            connections.push(connector);             
            connector.connections.push(this);  
            var pt:Point = getPosition()        
            dragConnectingSegments(connector.owner, pt.x, pt.y);                                          
        }     
            
        /**
         * Recursively drag all child semgents.
         */
        public function dragConnectingSegments(parentSegment:Segment,
                                     xpos:Number, ypos:Number):void
        {
        	 //trace("dragging xpos="+xpos);        	 
             drag(xpos, ypos, parentSegment);
             
             var pin:Point = getPosition();
             // drag the children of this connector
             dragChildSegments(connections, parentSegment, pin.x, pin.y);
             var conns:Array;
             if (isFront) {
                 pin = owner.rearConnector.getPosition();    
                 conns = owner.rearConnector.connections;     
             } else {
              	 pin = owner.frontConnector.getPosition();         
              	 conns = owner.frontConnector.connections;  
             }     
             // drag the children of the other connector on our owning segment.
             dragChildSegments(conns, parentSegment, pin.x, pin.y);      
        }
                
        
        private function dragChildSegments(connections:Array, 
                                           parentSegment:Segment, 
                                           xpos:Number, ypos:Number):void
        {
            for each (var c:Connector in connections)
            {
                if (c.owner != parentSegment)
                {
                    c.dragConnectingSegments(owner, xpos, ypos);
                }
            }
        }
        
        /**
         *  move the rear of the segment toward xpos, ypos
         */
        public function drag(xpos:Number, ypos:Number, adjacent:Segment):void
        {     
        	var oldPos:Point = getPosition();    
        	var rearPin:Point;
        	var dx:Number;
        	var dy:Number;
        	
        	if (isFront) {        			 
	            rearPin = owner.rearConnector.getPosition();      
	            dx = rearPin.x - xpos;
	            dy = rearPin.y - ypos;	                   
	            owner.rotation = determineNewRotation(dy, dx, adjacent);
	            //trace("from front ="+rotation);        
	            owner.x = xpos;
	            owner.y = ypos;	            
        	}
        	else {	        	  	      
	            var frontPin:Point = owner.frontConnector.getPosition();            
	            dx = xpos - frontPin.x;
	            dy = ypos - frontPin.y;
	            owner.rotation = determineNewRotation(dy, dx, adjacent);
	            //trace("from rear ="+rotation);	            
	            rearPin = getPosition();
	            var w:Number = rearPin.x - frontPin.x;
	            var h:Number = rearPin.y - frontPin.y;
	            owner.x = xpos - w;
	            owner.y = ypos - h;       	         
	        }
	        var newPos:Point = getPosition();
            vx = newPos.x - oldPos.x;
            vy = newPos.y - oldPos.y;     
        }     
     
        private function determineNewRotation(dy:Number, dx:Number, adjacent:Segment):Number {
        	var angle:Number = Math.atan2(dy, dx);           
	        return limitAngleIfNeeded(angle, adjacent) * Util.RAD_TO_DEG;
        }
        
        private function limitAngleIfNeeded(proposedAngle:Number, adjacent:Segment):Number
        {
        	return proposedAngle;
        	/*
        	// if the angle desired is to great, limit it.            
            var oldAngle:Number = rotation * DEG_TO_RAD;       
            var ang:Number = proposedAngle;        
            if (adjacent != null)
            {
	            var adjAngle:Number = adjacent.rotation;  
	            
	            if (Math.abs(proposedAngle - adjAngle) > angleLimit)
	            {
	            	trace("angle="+Math.abs(proposedAngle) + " to different from adjAngle="+
	            	    Math.abs(adjAngle) +" so limiting to "+oldAngle);
	            	if (proposedAngle - adjAngle > 0) {	            	
	            	    ang = adjAngle - angleLimit; 
	            	} else {
	            		ang = adjAngle + angleLimit; 
	            	}
	            }
            }
            return ang;
            */
        }
    }
}