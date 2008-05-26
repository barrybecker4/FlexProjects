package  com.becker.animation
{
    import com.becker.common.Segment;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.core.UIComponent;

    public class MultiSegmentDrag extends UIComponent implements Animatible
    {
        private var segments:Array;
        private var numSegments:uint = 100;
        private var dragSegment:Segment;
        
        public function MultiSegmentDrag() {}
        
        public function startAnimating():void
        {
            segments = new Array();
            var lastSegment:Segment;
            for(var i:uint = 0; i < numSegments; i++)
            {
                var segment:Segment = new Segment(50, 10);
                
                segment.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
                addChild(segment);                
                segments.push(segment);
                // connect each new segment to the one before it.
                if (i > 0) {
                    lastSegment.connect(segment, true, false);
                }
                lastSegment = segment;
            }
            dragSegment = null;
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            parent.addEventListener(MouseEvent.MOUSE_UP, unPress);    
        }
        
        private function onPress(evt:MouseEvent):void
        {
        	dragSegment = Segment(evt.target); 
        }
        
        private function unPress(evt:MouseEvent):void
        {
            dragSegment = null;
        }
        
        private function onEnterFrame(event:Event):void
        {
            if (dragSegment != null) {
                // now drag all the connected segments (recursively) accordingly.
                dragSegment.dragSegments(null, mouseX, mouseY);
            }
        }
    }
}
