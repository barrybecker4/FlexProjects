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
        
        [Bindable]
        public var showForce:Boolean = false;
        [Bindable]
        public var showVelocity:Boolean = false;
        
        // Elasticity. how much to bounce when hitting another object like a wall.
        private static const BOUNCE:Number = 0.1;
        
        private static const VEL_FACTOR:Number = 0.2;
        
        /** for drawing force and velocity vectors) */
        private static const FORCE_COLOR:uint = 0x1100aa;
        private static const FORCE_ALPHA:Number = 0.5;
        private static const VELOCITY_COLOR:uint = 0x00bb33;
        private static const VELOCITY_ALPHA:Number = 0.5;
        
        
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
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        public function get owner():Segment {
        	return owner_;
        }
        
        public function get isFront():Boolean {
        	return isFront_;
        }
     
        private function onEnterFrame(event:Event):void
        {  
        	graphics.clear();
        	graphics.lineStyle(0);
            graphics.beginFill(color);
            var xpos:int = isFront?0:owner.length;
            graphics.drawCircle(xpos, 0, radius);  
            graphics.endFill();   
            var adjPt:Point; 
                       
        	if (showForce) {
                graphics.lineStyle(1, FORCE_COLOR, FORCE_ALPHA); 
                adjPt = adjustForRotation(force);             
                graphics.lineTo(adjPt.x + xpos, adjPt.y);
            }
            if (showVelocity) {
                graphics.lineStyle(1, VELOCITY_COLOR, VELOCITY_ALPHA);
                graphics.moveTo(0, 0);
                adjPt = adjustForRotation(new Vector2d(1.0 * velocity.x, 1.0 * velocity.y));   
                graphics.lineTo(adjPt.x + xpos, adjPt.y);
            }
        }
        
        /**
         * subtract the angle that the owning segment is rotated.
         */
        public function adjustForRotation(adjPoint:Vector2d):Point
        {
        	var len:Number = adjPoint.length;
        	var ang:Number = Math.atan2(adjPoint.y, adjPoint.x);
        	var adjAng:Number = ang - owner.rotation * Util.DEG_TO_RAD;
        	var newPt:Point = new Point(Math.cos(adjAng) * len, Math.sin(adjAng) * len);
        	return newPt;
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
        	//var oppPos:Point = getOppositeConnector().getPosition();  
        	if (isFront) {
        		owner_.x = pt.x;
        		owner_.y = pt.y;       		
        		//owner_.rotation = Math.atan2(oppPos.y - pt.y, oppPos.x - pt.x) * Util.RAD_TO_DEG;
        	} else {
        		var angle:Number = Util.DEG_TO_RAD * owner_.rotation;
	            owner_.x = pt.x - Math.cos(angle) * owner_.length;
	            owner_.y = pt.y - Math.sin(angle) * owner_.length;	
	            //owner_.rotation = Math.atan2(pt.y - oppPos.y, pt.x - oppPos.x) * Util.RAD_TO_DEG;           
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
	        //var newPos:Point = getPosition();
	        //velocity = new Vector2d(newPos.x - oldPos.x, newPos.y - oldPos.y); 
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
        	        
         	velocity.x += force.x;
        	velocity.y += (force.y + gravity);
        	force.x = 0;
        	force.y = 0;
        	var pt:Point = getPosition();
        	pt.x += velocity.x * VEL_FACTOR;
    		pt.y += velocity.y * VEL_FACTOR; 
    		
    		// must do 3 steps
    		// 1) update velocities based on all forces.
    		// 2) update positions based on all velocities
    		// 3) apply constraints (i.e rigid segments must be maintained).
    		var bounced:Boolean = false;
    		
    		   
    		// bounce if hit a wall   		
    		if (pt.x > width + radius) {
    			pt.x = width - radius; //2.0 * width - pt.x - radius;
    			velocity.x *= -BOUNCE;  	 	
    			bounced = true;	
    		}
    		if (pt.x - radius < 0.0) {
    			pt.x = radius;
    			velocity.x *= -BOUNCE;  
    			bounced = true;		
    		}    
    		if (pt.y > height + radius) {
    			pt.y = height - radius; //2.0 * height - pt.y;
    			velocity.y *= -BOUNCE; 
    			bounced = true;		
    		}
    		if (pt.y - radius < 0.0) {
    			pt.y = radius; //-pt.y; 
    			velocity.y *= -BOUNCE; 
    			bounced = true;		
    		}     
    		
    	    setPosition(pt);
    		//dragConnectingSegments(owner, pt.x, pt.y);  
    		return bounced;   
        }
        
        override public function toString():String
        {
        	var pt:Point = this.getPosition();
            return "Connector x=" + pt.x + " y=" + pt.y;
        }
    }
}