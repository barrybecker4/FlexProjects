package com.becker.animation {
	
    import com.becker.common.Ball;   
    import flash.events.Event;   
    import mx.core.UIComponent;
    
    public class Bouncing extends UIComponent implements Animatible {
		
        private var ball:Ball;
        
        private var origWidth:Number = 1;
        private var origHeight:Number = 1;
        
        private static const SPEED:int = 10;
        private static const RADIUS:int = 40;
        
        public function Bouncing() {}
        
        public function startAnimating():void {
        	origWidth = this.width;
            origHeight = this.height;            
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);  
            this.invalidateDisplayList();                      
        }
        
        override protected function createChildren():void {
            ball = new Ball(RADIUS);
            ball.x = this.width / 2.0;
            ball.y = this.height / 2.0;
			ball.xVelocity = SPEED * Math.sin(Math.random());
			ball.yVelocity = SPEED * Math.cos(Math.random()); 
            
            addChild(ball);       
        }
        
        override protected function updateDisplayList(w:Number, h:Number):void {
            super.updateDisplayList(w, h);
            
            var xscale:Number = this.width / origWidth;
            var yscale:Number = this.height / origHeight;
            var scale:Number = Math.min(xscale, yscale);

            ball.radius = RADIUS * scale; 
        }
        
        private function onEnterFrame(event:Event):void {        
            ball.bounce(0.9, 1.0, this);            
        }
    }
}
