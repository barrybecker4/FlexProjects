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
        
        private var origWidth:Number = 1;
        private var origHeight:Number = 1;
        
        private static const SPEED:int = 10;
        private static const RADIUS:int = 40;
        
        public function Bouncing()
        {            
        }
        
        public function startAnimating():void
        {
        	origWidth = this.width;
            origHeight = this.height;            
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);  
            this.invalidateDisplayList();                      
        }
        
        override protected function createChildren():void {
            ball = new Ball(40);
            ball.x = this.width / 2.0;
            ball.y = this.height / 2.0;
            vx = SPEED * Math.sin(Math.random());
            vy = SPEED * Math.cos(Math.random()); 
            
            addChild(ball);       
        }
        
        override protected function updateDisplayList(w:Number, h:Number):void {
            super.updateDisplayList(w, h);
            
            var xscale:Number = this.width / origWidth;
            var yscale:Number = this.height / origHeight;
            var scale:Number = Math.min(xscale, yscale);

            ball.radius = RADIUS * scale; 
        }
        
        private function onEnterFrame(event:Event):void
        {
            ball.x += vx;
            ball.y += vy;
            var left:Number = 0;
            var right:Number = this.width;
            var top:Number = 0;
            var bottom:Number = this.height;
            
            ball.bounce(1.2, 1.0, this);            
        }
    }
}
