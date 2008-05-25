package com.becker.common
{
	import flash.geom.Point;	
	import mx.core.UIComponent;
	
	/**
	 * Represents a 2D ball and common operations on it.
	 */
	public class Ball extends UIComponent  {
		public var radius:Number;
		private var color:uint;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var mass:Number = 1.0;
		
		public function Ball(radius:Number=40, color:uint=0xff0000) {
			this.radius = radius;
			this.color = color;
			init();
		}
		public function init():void {
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		}
		
		/** 
         * controls the bouncing ball.
         * @param bounce controls the elasticity fo the bounce (1 = totally elastic)
         */
		public function bounce(bounce:Number, gravity:Number, 
		                           container:UIComponent):void
		{
			vy += gravity;
			x += vx;
			y += vy;
			if(x + radius > container.width)
			{
				x = container.width - radius;
				vx *= bounce;
			}
			else if(x - radius < 0)
			{
				x = radius;
				vx *= bounce;
			}
			if(y + radius > container.height)
			{
				y = container.height - radius;
				vy *= bounce;
			}
			else if(y - radius < 0)
			{
				y = radius;
				vy *= bounce;
			}
		}	
		
		/**
		 * Check for and handle a collision with another ball.
		 */
		public function handleCollision(ball1:Ball):void
		{
			var dx:Number = ball1.x - x;
			var dy:Number = ball1.y - y;
			var dist:Number = Math.sqrt(dx*dx + dy*dy);
			if(dist < radius + ball1.radius)
			{
				// calculate angle, sine and cosine
				var angle:Number = Math.atan2(dy, dx);
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle);
				
				// rotate our position
				var pos0:Point = new Point(0, 0);
				
				// rotate ball1's position
				var pos1:Point = Util.rotate(dx, dy, sin, cos, true);
				
				// rotate our velocity
				var vel0:Point = Util.rotate(vx,
										vy,
										sin,
										cos,
										true);
				
				// rotate ball1's velocity
				var vel1:Point = Util.rotate(ball1.vx,
										ball1.vy,
										sin,
										cos,
										true);
				
				// collision reaction
				var vxTotal:Number = vel0.x - vel1.x;
				vel0.x = ((mass - ball1.mass) * vel0.x + 
				          2 * ball1.mass * vel1.x) / 
				          (mass + ball1.mass);
				vel1.x = vxTotal + vel0.x;

				// update position
				var absV:Number = Math.abs(vel0.x) + Math.abs(vel1.x);
				var overlap:Number = (radius + ball1.radius) 
				                      - Math.abs(pos0.x - pos1.x);
				pos0.x += vel0.x / absV * overlap;
				pos1.x += vel1.x / absV * overlap;
				
				// rotate positions back
				var pos0F:Object = Util.rotate(pos0.x,
										  pos0.y,
										  sin,
										  cos,
										  false);
										  
				var pos1F:Object = Util.rotate(pos1.x,
										  pos1.y,
										  sin,
										  cos,
										  false);

				// adjust positions to actual screen positions
				ball1.x = x + pos1F.x;
				ball1.y = y + pos1F.y;
				x = x + pos0F.x;
				y = y + pos0F.y;
				
				// rotate velocities back
				var vel0F:Object = Util.rotate(vel0.x,
										  vel0.y,
										  sin,
										  cos,
										  false);
				var vel1F:Object = Util.rotate(vel1.x,
										  vel1.y,
										  sin,
										  cos,
										  false);
				vx = vel0F.x;
				vy = vel0F.y;
				ball1.vx = vel1F.x;
				ball1.vy = vel1F.y;
			}
		}	
	}
}