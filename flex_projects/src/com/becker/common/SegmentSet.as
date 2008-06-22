package com.becker.common
{
    import flash.display.Sprite;

    /**
     * A set of connected segments.
     * You can add segments by specifying a new segment and a connection to another 
     * segment already in the set.
     * When removing segments, you may split this set into 2 sets.          
     *  
     * @author Barry Becker                       
     */ 
    public class SegmentSet 
    {
        /** all the segments in the set */
        private var segments:Array;
        
        
        public function SegmentSet() {
            segments = new Array();
        }
        
        public function add(segment:Segment, isFront:Boolean, connector:Connector):void {
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
        }
        
        
        public function updateDynamics(gravity:Number, width:int, height:int):void {
        	for each (var segment:Segment in segments) {
	        	segment.updateDynamics(gravity, width, height);        		
	        }
        }
        
       
        public function toString():String
        {        	
            var s:String = "Segment Set:\n";
            for each (var segment:Segment in segments) {
               s += segment.toString() + "\n";
            }
            return s;
        }
    }
}