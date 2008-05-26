package com.becker.animation
{
    import com.becker.common.Ball;
    
    import flash.events.Event;
    
    import mx.core.UIComponent;
    
    public class Bouncing extends UIComponent implements Animatible
    {
        private var ball:Ball;
        private var vx:Number;
        private var vy:Number;
        
        private static const SPEED:int = 40;
        
        public function Bouncing()
        {            
        }
        
        public function startAnimating():void
        {
            ball = new Ball();
            addChild(ball);        
            ball.x = this.width / 2;
            ball.y = this.height / 2;
            vx = SPEED * Math.sin(Math.random());
            vy = SPEED * Math.cos(Math.random());    
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);                        
        }
        
        private function onEnterFrame(event:Event):void
        {
            ball.x += vx;
            ball.y += vy;
            var left:Number = 0;
            var right:Number = this.width;
            var top:Number = 0;
            var bottom:Number = this.height;
            
            ball.bounce(0.0, 1.0, this);            
        }
    }
}
