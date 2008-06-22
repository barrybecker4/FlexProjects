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
        
        // true if this connector is as the front of the segment.
        private var isFront_:Boolean;
        
        // other segment connectors that we are connected to.
        private var connections:Array;
        
        // force vector
        public var force:Vector2d;
         
        // velocity vector
        public var velocity:Vector2d;
        
        private var radius:Number;
        private var color:uint;
        private var mass:Number;
        
        // Elasticity. how much to bounce when hitting another object like a wall.
        private static const BOUNCE:Number = 0.8;
        
        private static const VEL_FACTOR:Number = 0.2;
        
        public function Connector(owner:Segment, isFront:Boolean, color:uint = 0x88ff00, mass:Number = 1.0)                                 
        {
        	this.owner_ = owner;
        	this.isFront_ = isFront;
            this.radius = owner.thickness/2.0 - 2;  
            connections = new Array();
            this.color = color;
            this.mass = mass;
            velocity = new Vector2d(0, 0);
            force = new Vector2d(0, 0);
            init();
        }
        
        public function get owner():Segment {
        	return owner_;
        }
        
        public function get isFront():Boolean {
        	return isFront_;
        }
        
        public function init():void {          
        	graphics.lineStyle(0);
        	graphics.beginFill(color);
            graphics.drawCircle(isFront?0:owner.length, 0, radius);  
            graphics.endFill();
        }        
      
        /**
         * On the left or right of the owning segment.
         */
        public function getPosition():Point {      	
        	if (isFront) {
                return new Point(owner_.x, owner_.y);
            } else {
            	var angle:Number = Util.DEG_TO_RAD * owner_.rotation;
	            var xpos:Number = owner_.x + Math.cos(angle) * owner_.length;
	            var ypos:Number  = owner_.y + Math.sin(angle) * owner_.length;
	            return new Point(xpos, ypos);
            }         
        }
        
        private function setPosition(pt:Point):void {
        	//trace("setPosition "+ (isFront?"front":"rear") + " angle="+owner_.rotation + "  x=" +Util.round(owner_.x,1) + " y=" +Util.round(owner_.y,2));
        	if (isFront) {
        		owner_.x = pt.x;
        		owner_.y = pt.y;
        	} else {
        		var angle:Number = Util.DEG_TO_RAD * owner_.rotation;
	            owner_.x = pt.x - Math.cos(angle) * owner_.length;
	            owner_.y = pt.y - Math.sin(angle) * owner_.length;	           
        	}
        	//trace(" - angle="+owner_.rotation + " vx="+Util.round(vx, 2)+" vy="+Util.round(vy, 2)+"       x="+Util.round(owner_.x, 1) + " y="+Util.round(owner_.y, 1));
        }
                
        /**
         * connect this segment with another.
         * @param connector to connect to
         */         
        public function connect(connector:Connector):void {           
            connections.push(connector);             
            connector.connections.push(this);  
            var pt:Point = getPosition()        
            dragConnectingSegments(connector.owner, pt);                                          
        }     
            
        /**
         * Recursively drag all child semgents.
         */
        public function dragConnectingSegments(parentSegment:Segment, pos:Point):void {
             drag(pos, parentSegment);
             
             var pin:Point = getPosition();
             // drag the children of this connector
             dragChildSegments(connections, parentSegment, pin);
             var conns:Array;
             if (isFront) {
                 pin = owner.rearConnector.getPosition();    
                 conns = owner.rearConnector.connections;     
             } else {
              	 pin = owner.frontConnector.getPosition();         
              	 conns = owner.frontConnector.connections;  
             }     
             // drag the children of the other connector on our owning segment.
             dragChildSegments(conns, parentSegment, pin);      
        }
                
        
        private function dragChildSegments(connections:Array, 
                                           parentSegment:Segment, 
                                           pos:Point):void {
            for each (var c:Connector in connections)
            {
                if (c.owner != parentSegment)
                {
                    c.dragConnectingSegments(owner, pos);
                }
            }
        }
        
        /**
         *  move the connector toward xpos, ypos
         */
        public function drag(pos:Point, adjacent:Segment):void {     
        	var oldPos:Point = getPosition();    
        	var rearPin:Point;
        	var dx:Number;
        	var dy:Number;
        	
        	if (isFront) {        			 
	            rearPin = owner.rearConnector.getPosition();      
	            dx = rearPin.x - pos.x;
	            dy = rearPin.y - pos.y;	                   
	            owner.rotation = determineNewRotation(dy, dx, adjacent);
	            owner.x = pos.x;
	            owner.y = pos.y;	            
        	}
        	else {	        	  	      
	            var frontPin:Point = owner.frontConnector.getPosition();            
	            dx = pos.x - frontPin.x;
	            dy = pos.y - frontPin.y;
	            owner.rotation = determineNewRotation(dy, dx, adjacent);
	            rearPin = getPosition();
	            var w:Number = rearPin.x - frontPin.x;
	            var h:Number = rearPin.y - frontPin.y;
	            owner.x = pos.x - w;
	            owner.y = pos.y - h;       	         
	        }
	        var newPos:Point = getPosition();
	        var velChange:Vector2d = new Vector2d(newPos.x - oldPos.x, newPos.y - oldPos.y);
	        velChange.scale(VEL_FACTOR);
            velocity.add(velChange);     
        }     
     
        private function determineNewRotation(dy:Number, dx:Number, adjacent:Segment):Number {
        	var angle:Number = Math.atan2(dy, dx);           
	        return limitAngleIfNeeded(angle, adjacent) * Util.RAD_TO_DEG;
        }
        
        private function limitAngleIfNeeded(proposedAngle:Number, 
                                            adjacent:Segment):Number {
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
        
        private function getOppositeConnector():Connector {
        	return (isFront)? owner.rearConnector: owner.frontConnector;       	
        }
       
        /**
         * When the segment hits the wall,
         * The opposite pins velocity is changed by the component in the direction of the segment.
         */
        public function updateDynamics(gravity:Number, width:Number, height:Number):Boolean {
        	        	
        	velocity.y += gravity * 1.0;
        	var pt:Point = getPosition();
        	pt.x += velocity.x * VEL_FACTOR;
    		pt.y += velocity.y * VEL_FACTOR; 
    		var oppositeConnector:Connector = getOppositeConnector();
    		var bounced:Boolean = false;
    		
    		   
    		// bounce if hit a wall   		
    		if (pt.x > width) {
    			pt.x = 2.0 * width - pt.x;
    			velocity.x *= -BOUNCE;  	 	
    			bounced = true;	
    		}
    		if (pt.x < 0.0) {
    			pt.x = -pt.x;
    			velocity.x *= -BOUNCE;  
    			bounced = true;		
    		}    
    		if (pt.y > height) {
    			pt.y = 2.0 * height - pt.y;
    			velocity.y *= -BOUNCE; 
    			bounced = true;		
    		}
    		if (pt.y < 0.0) {
    			pt.y = -pt.y; 
    			velocity.y *= -BOUNCE; 
    			bounced = true;		
    		}     
    		
    	    setPosition(pt);
    		//dragConnectingSegments(owner, pt.x, pt.y);  
    		return bounced;   
        }
    }
}