package com.becker.common
{
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Segment extends Sprite
	{
		private static const DEFAULT_PIN_RADIUS:Number = 2.0;
		
		// velocity vector
		public var vx:Number = 0;
		public var vy:Number = 0;
		
		private var color:uint;
		private var segmentWidth:Number;
		private var segmentHeight:Number;	
		
		// child connections
		private var frontConnections:Array;
		private var rearConnections:Array;
		
		public function Segment(segmentWidth:Number, segmentHeight:Number, color:uint = 0xffffff)
		{
			this.segmentWidth = segmentWidth;
			this.segmentHeight = segmentHeight;
			this.color = color;
			this.frontConnections = new Array();
			this.rearConnections = new Array();
			init();
		}
		
		public function init():void
		{
			// draw the segment itself
			graphics.lineStyle(0);
			graphics.beginFill(color);
			graphics.drawRoundRect(-segmentHeight / 2, 
								   -segmentHeight / 2,
								   segmentWidth + segmentHeight,
								   segmentHeight,
								   segmentHeight,
								   segmentHeight);
			graphics.endFill();
			
			// draw the two "pins"
			graphics.drawCircle(0, 0, DEFAULT_PIN_RADIUS);
			graphics.drawCircle(segmentWidth, 0, DEFAULT_PIN_RADIUS);
		}
		
		public function getFrontPin():Point
		{
			return new Point(x, y);
		}
		
		public function getRearPin():Point
		{
			var angle:Number = rotation * Math.PI / 180;
			var xPos:Number = x + Math.cos(angle) * segmentWidth;
			var yPos:Number = y + Math.sin(angle) * segmentWidth;
			return new Point(xPos, yPos);
		}
		
		/**
		 * connect this segment with another.
		 * @param segment segment to connect to
		 * @param front if the segment is connecting to our front.
		 * @param toFront we are connecting to its front.
		 */		 
		public function connect(segment:Segment, front:Boolean, toFront:Boolean):void
		{
			if (front) {
			    frontConnections.push(segment);
			} else {
				rearConnections.push(segment);
			}
			if (toFront) {
				segment.frontConnections.push(this);
			} else {
				segment.rearConnections.push(this);
			}
			
		}
	}
}