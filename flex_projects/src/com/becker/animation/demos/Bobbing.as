package com.becker.animation.demos
{
    import com.becker.animation.Animatible;
    import com.becker.common.Ball;    
    import flash.events.Event;    
    import mx.core.UIComponent;
    
    public class Bobbing extends UIComponent implements Animatible {
        private var ball:Ball;
        private var angle:Number = 0;
        private var centerY:Number = 200;
        private var range:Number = 50;
        private var speed:Number = .1;
        
        public function Bobbing() {            
        }
        
        public function startAnimating():void {
            ball = new Ball();
            addChild(ball);
            ball.x = this.width / 2;
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        public function onEnterFrame(event:Event):void {
            ball.y = centerY + Math.sin(angle) * range;
            angle += speed;
        }
    }
}