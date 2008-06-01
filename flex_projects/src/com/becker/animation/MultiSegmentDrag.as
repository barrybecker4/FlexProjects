package  com.becker.animation
{
    import com.becker.common.Connector;
    import com.becker.common.Segment;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import mx.core.UIComponent;

    public class MultiSegmentDrag extends UIComponent implements Animatible
    {
    	private static const DEFAULT_SEGMENT_LENGTH:Number = 60;
        private var segments:Array;
        private var numSegments:uint = 300;
        private var draggedConnector:Connector;
        private var lastDraggedConnector:Connector;
        private var lastDragVelocity:Point;
        private var lastX:Number;
        private var lastY:Number;
        private var gravity:Number = 0.98;
        private var bounce:Number = 0.9
        
        public function MultiSegmentDrag() {}
        
        public function startAnimating():void
        {
            segments = new Array();
            var lastSegment:Segment;
            for (var i:uint = 0; i < numSegments; i++)
            {
                var segment:Segment = 
                    new Segment(DEFAULT_SEGMENT_LENGTH, 12,  0x0fff88);
                
                segment.frontConnector.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
                segment.rearConnector.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
                addChild(segment);                
                segments.push(segment);
                // connect each new segment to the one before it.
                if (i == 0) {
                	segment.x = 20;
                	segment.y = 20;           
                } else {
                	segment.y = lastSegment.y + 3;
                	segment.x = lastSegment.x + lastSegment.length;
                	lastSegment.rearConnector.connect(segment.frontConnector);        
                }
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
        	    lastDragVelocity = new Point(mouseX - lastX, mouseY - lastY);
        	}
            draggedConnector = null;
        }
        
        private function onEnterFrame(event:Event):void
        {
        	if (lastDraggedConnector == null && draggedConnector == null) return;
        	
        	// update positions based on current velocity
        	/*
        	for each (var segment:Segment in segments) {
        		segment.vy += gravity * 1.0;
        		segment.x += segment.vx * 1.0;
        		segment.y += segment.vy * 1.0;    
        		// bounce if hit a wall
        		//var rear:Point = segment.getRearPin();
        		if (segment.x > width ) {
        			segment.x = width;
        			segment.vx *= -bounce;
        		}
        		if (segment.x < 0) {
        			segment.x = 0;
        			segment.vx *= -bounce;
        		}    
        		if (segment.y > height) {
        			segment.y = height;
        			segment.vy *= -bounce;
        		}
        		if (segment.y < 0) {
        			segment.y = 0;
        			segment.vy *= -bounce;
        		}     		
        	}*/
        	
            if (draggedConnector != null && 
                mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
                lastX = mouseX;
                lastY = mouseY;
                // drag all the connected segments (recursively) accordingly.               
                draggedConnector.dragConnectingSegments(null, mouseX, mouseY);
            }
            else if (lastDraggedConnector != null) {
            	// keep going at the last drag velocity
            	//lastDragSegment.dragConnectingSegments(null, 
            	//    lastDragSegment.x + lastDragVelocity.x, 
            	//    lastDragSegment.y + lastDragVelocity.y);        	
            }            
        }
    }
}
