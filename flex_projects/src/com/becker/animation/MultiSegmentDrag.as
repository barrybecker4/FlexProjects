package  com.becker.animation
{
    import com.becker.common.Connector;
    import com.becker.common.Segment;
    import com.becker.common.SegmentSet;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import mx.core.UIComponent;

    public class MultiSegmentDrag extends UIComponent implements Animatible
    {
    	private static const DEFAULT_SEGMENT_LENGTH:Number = 60;
        private var segments:SegmentSet;
        private var numSegments:uint = 10;
        private var draggedConnector:Connector;
        private var lastDraggedConnector:Connector;
        //private var lastDragVelocity:Point;
        //private var lastX:Number;
        //private var lastY:Number;
        
        public var gravity:Number = 0.9;
        public var gravityEnabled:Boolean = false;
        
        public var friction:Number = 0.9;
        public var frictionEnabled:Boolean = false;
        
        public var enableSimulation:Boolean = false;
        
        
        public function MultiSegmentDrag() {}
        
        public function startAnimating():void
        {
            segments = new SegmentSet();
            var lastSegment:Segment;
            for (var i:uint = 0; i < numSegments; i++)
            {
                var segment:Segment = 
                    new Segment(DEFAULT_SEGMENT_LENGTH, 12,  0x0fff88);
                
                segment.frontConnector.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
                segment.rearConnector.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
                addChild(segment);                                
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
                segments.add(segment, true, connector);
                lastSegment = segment;
            }
            draggedConnector = null;
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            parent.addEventListener(MouseEvent.MOUSE_UP, unPress);    
        }
        
        private function onPress(evt:MouseEvent):void
        {
            draggedConnector = Connector(evt.target); 
        	evt.stopImmediatePropagation();
        }
        
        private function unPress(evt:MouseEvent):void
        {
        	if (draggedConnector != null) {
        	    lastDraggedConnector = draggedConnector;
        	    //lastDragVelocity = new Point(mouseX - lastX, mouseY - lastY);
        	}
            draggedConnector = null;
        }
        
        private function onEnterFrame(event:Event):void
        {
        	if (lastDraggedConnector == null && draggedConnector == null) return;
        	
        	// update positions based on current velocity       
        	if (enableSimulation) { 
        		segments.updateDynamics(gravityEnabled?gravity:0, width, height);		        	
	        }
        	
            if (draggedConnector != null && 
                mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
                //lastX = mouseX;
                //lastY = mouseY;
                // drag all the connected segments (recursively) accordingly.               
                draggedConnector.dragConnectingSegments(null, new Point(mouseX, mouseY));
            }
            else if (lastDraggedConnector != null && enableSimulation) {
            	// keep going at the last drag velocity
            	var pt:Point = lastDraggedConnector.getPosition();
            	/*           	           	
            	lastDraggedConnector.dragConnectingSegments(null, 
            	        pt.x + lastDragVelocity.x, 
            	        pt.y + lastDragVelocity.y);  
            	*/   
            	lastDraggedConnector.dragConnectingSegments(null, pt);   	
            }            
        }
    }
}
