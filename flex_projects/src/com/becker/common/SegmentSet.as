package com.becker.common
{
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    /**
     * A set of connected segments.
     * You can add segments by specifying a new segment and a connection to another 
     * segment already in the set.
     * When removing segments, you may split this set into 2 sets.          
     *  
     * @author Barry Becker                       
     */ 
    public class SegmentSet extends Sprite
    {
        /** all the segments in the set */
        private var segments:Array;
        
        
        public function SegmentSet() {
            segments = new Array();
        }
        
        public function addSegment(segment:Segment, isFront:Boolean, connector:Connector):void {
            if (connector == null && segments.length > 0) {
                throw new Error("You can only have a null connector when adding the first segment to the set.");
            }
            segments.push(segment);
            if (connector != null) {            
                if (isFront) {
                    connector.connect(segment.frontConnector); 
                } else {
                    connector.connect(segment.rearConnector); 
                }
            }
            addChild(segment);
        }
        
        public function initializeSegmentString(numSegments:Number, segmentLength:Number):void
        {
        	var lastSegment:Segment;
            for (var i:uint = 0; i < numSegments; i++)
            {
                var segment:Segment = 
                    new Segment(segmentLength, 12,  0x0fff88);
                
                //addChild(segment);                                
                // connect each new segment to the one before it.
                var connector:Connector = null;
                if (i == 0) {
                    segment.x = 20;
                    segment.y = 20;           
                } else {
                    segment.y = lastSegment.y + 3;
                    segment.x = lastSegment.x + lastSegment.length;
                    connector = lastSegment.rearConnector;       
                }
                this.addSegment(segment, true, connector);
                lastSegment = segment;
            }
        }
        
        public function set showForces(show:Boolean):void {
            for each (var segment:Segment in segments)
            {
            	segment.frontConnector.showForce = show;
            	segment.rearConnector.showForce = show;
            }
        }
        
        public function set showVelocities(show:Boolean):void {
            for each (var segment:Segment in segments)
            {
                segment.frontConnector.showVelocity = show;
                segment.rearConnector.showVelocity = show;
            }
        }
        
        /**
         * find connector closest to the specified point within some max threshold.
         */
        public function findClosestConnector(x:Number, y:Number, 
                                             maxDistanceThreshold:Number = 200):Connector
        {
            var here:Point = new Point(x, y);
            // dont consider connector if we have alread seen it.
            var connectorHash:Dictionary = new Dictionary();
            var minDistance:Number = 100000000;
            var dist:Number;
            var closestConnector:Connector;
            for each (var seg:Segment in segments) {
                if (!connectorHash[seg.frontConnector]) {
                    connectorHash[seg.frontConnector] = true;
                    dist = Util.distance(seg.frontConnector.getPosition(), here);
                    if (dist < minDistance) {
                        minDistance = dist;
                        closestConnector = seg.frontConnector;
                    }
                }
                if (!connectorHash[seg.rearConnector]) {
                    connectorHash[seg.rearConnector] = true;
                    dist = Util.distance(seg.rearConnector.getPosition(), here);
                    if (dist < minDistance) {
                        minDistance = dist;
                        closestConnector = seg.rearConnector;
                    }
                }
            }
            if (minDistance > maxDistanceThreshold) {
                return null;
            }
            return closestConnector;            
        }
        
        
        public function updateDynamics(gravity:Number, width:int, height:int):void {
            for each (var segment:Segment in segments) {                
                segment.updateDynamics(gravity, width, height);                
            }
        }
        
       
        override public function toString():String
        {
            var s:String = "Segment Set:\n";
            for each (var segment:Segment in segments) {
               s += segment.toString() + "\n";
            }
            return s;
        }
    }
}