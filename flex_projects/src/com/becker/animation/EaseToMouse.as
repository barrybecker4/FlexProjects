package com.becker.animation
{
	import com.becker.animation.Animatible;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class EaseToMouse extends UIComponent implements Animatible
	{
		private var ball:Ball;
		private var easing:Number = 0.2;
		
		public function EaseToMouse()
		{		
		}
		
		public function startAnimating():void
		{
			ball = new Ball();
			addChild(ball);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		
		private function onEnterFrame(event:Event):void
		{
			var vx:Number = (mouseX - ball.x) * easing;
			var vy:Number = (mouseY - ball.y) * easing;
			ball.x += vx;
			ball.y += vy;
		}
	}
}
