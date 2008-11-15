package  com.becker.animation
{
    import com.becker.common.Connector;
    import com.becker.common.SegmentSet;
    import com.becker.common.Vector2d;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import mx.core.UIComponent;

    /**
     * Simulate the dragging of a bunch of segments with a rubber band (spring).
     * When the user clicks they attach to the nearest segment connector (within tolerance).
     * That attachment is represented by a stretched spring with applies a force to that 
     * connector proportional to the distance to the mouse position.
     */
    public class MultiSegmentDrag extends UIComponent implements Animatible
    {
    	private static const DEFAULT_SEGMENT_LENGTH:Number = 60;
    	// effectively the spring constant used when dragging in simulation mode.
    	private static const DRAG_SCALE:Number = 0.02;
        private var segments:SegmentSet;
        private var numSegments:uint = 20;
        private var draggedConnector:Connector;
        private var lastDraggedConnector:Connector;
      
        
        [Bindable]
        public var gravity:Number = 0.9;
        [Bindable]
        public var gravityEnabled:Boolean = false;
        
        [Bindable]
        public var friction:Number = 0.9;
        [Bindable]
        public var frictionEnabled:Boolean = false;
        
        [Bindable]
        public var enableSimulation:Boolean = false;
        
        
        /**
         * constructor
         */
        public function MultiSegmentDrag() {}
        
        public function startAnimating():void
        {
            segments = new SegmentSet();
            segments.initializeSegmentString(numSegments, DEFAULT_SEGMENT_LENGTH);
            addChild(segments);
            
            draggedConnector = null;
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            parent.addEventListener(MouseEvent.MOUSE_DOWN, onPress)
            parent.addEventListener(MouseEvent.MOUSE_UP, unPress);    
        }
        
        public function set showForces(show:Boolean):void {
        	segments.showForces = show;
        }
        
        public function set showVelocities(show:Boolean):void {
        	segments.showVelocities = show;
        }
        
        private function onPress(evt:MouseEvent):void
        {       	
            draggedConnector = segments.findClosestConnector(mouseX, mouseY);
            lastDraggedConnector = draggedConnector;
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
        	
        	var pos:Point;
        	// update positions based on current velocity    
        	if (enableSimulation) { 
        		segments.updateDynamics(gravityEnabled? gravity : 0, width, height);		        	
	        }
        	
            if (draggedConnector != null && !enableSimulation &&
                mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
                // drag all the connected segments (recursively) accordingly.   
                pos = new Point(mouseX, mouseY);               
                draggedConnector.dragConnectingSegments(null, pos);
            }
            else if (lastDraggedConnector != null && enableSimulation) {
            	
            	if (draggedConnector != null) {            	
            	    pos = draggedConnector.getPosition();
                    draggedConnector.force = new Vector2d((mouseX - pos.x)*DRAG_SCALE, (mouseY - pos.y)*DRAG_SCALE);
                }
                
            	// keep going at the last drag velocity
            	pos = lastDraggedConnector.getPosition();
            	lastDraggedConnector.dragConnectingSegments(null, pos);   	
            }            
        }
    }
}
