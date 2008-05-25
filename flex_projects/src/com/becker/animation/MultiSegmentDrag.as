package  com.becker.animation
{
	import com.becker.common.Segment;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	public class MultiSegmentDrag extends UIComponent implements Animatible
	{
		private var segments:Array;
		private var numSegments:uint = 50;
		private var dragSegment:Segment;
		
		public function MultiSegmentDrag() {}
		
		public function startAnimating():void
		{
			segments = new Array();
			for(var i:uint = 0; i < numSegments; i++)
			{
				var segment:Segment = new Segment(50, 10);
				segment.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
				addChild(segment);				
				segments.push(segment);
			}
			dragSegment = null;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.MOUSE_UP, unPress);			
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
			drag(dragSegment, mouseX, mouseY);
			// now drag all the connected segments (recursively) accordingly.
			for(var i:uint = 1; i < numSegments; i++)
			{
				var segmentA:Segment = segments[i];
				var segmentB:Segment = segments[i - 1];
				drag(segmentA, segmentB.x, segmentB.y);
			}
		}
		
		
		
		private function drag(segment:Segment, xpos:Number, ypos:Number):void
		{
			var frontPin:Point = segment.getFrontPin();
			
			var dx:Number = xpos - frontPin.x;
			var dy:Number = ypos - frontPin.y;
			var angle:Number = Math.atan2(dy, dx);
			segment.rotation = angle * 180 / Math.PI;
			
			var rearPin:Point = segment.getRearPin();
			var w:Number = rearPin.x - segment.x;
			var h:Number = rearPin.y - segment.y;
			segment.x = xpos - w;
			segment.y = ypos - h;
		}
	}
}
