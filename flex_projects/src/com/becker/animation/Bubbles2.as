package com.becker.animation
{
    import com.becker.common.Ball;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.core.UIComponent;
    
    public class Bubbles2 extends UIComponent implements Animatible
    {
        private var balls:Array;
        private var numBalls:Number = 30;
        private var bounce:Number = -0.5;
        private var spring:Number = 0.05;
        private var gravity:Number = 0.1;
        
        private var draggedBall:Ball;
        
        public function Bubbles2() {}
        
        
        public  function startAnimating():void {
            balls = new Array();
            
            for(var i:uint = 0; i < numBalls; i++) {
                var ball:Ball = new Ball(Math.random() * 30 + 20, Math.random() * 0xffffff);
                ball.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
                
                ball.x = Math.random() * stage.stageWidth;
                ball.y = Math.random() * stage.stageHeight;
                ball.xVelocity = Math.random() * 6 - 3;
                ball.yVelocity = Math.random() * 6 - 3;
                addChild(ball);
                balls.push(ball);
            }
            
            this.addEventListener(MouseEvent.MOUSE_UP, onRelease);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);            
        }
        
        private function onEnterFrame(event:Event):void {
			
            for(var i:uint = 0; i < numBalls - 1; i++) {
                var ball0:Ball = balls[i];
                for(var j:uint = i + 1; j < numBalls; j++){
                    var ball1:Ball = balls[j];
                    var dx:Number = ball1.x - ball0.x;
                    var dy:Number = ball1.y - ball0.y;
                    var dist:Number = Math.sqrt(dx * dx + dy * dy);
                    var minDist:Number = ball0.radius + ball1.radius;
                    if(dist < minDist) {
                        var angle:Number = Math.atan2(dy, dx);
                        var tx:Number = ball0.x + dx / dist * minDist;
                        var ty:Number = ball0.y + dy / dist * minDist;
                        var ax:Number = (tx - ball1.x) * spring;
                        var ay:Number = (ty - ball1.y) * spring;
                        ball0.xVelocity -= ax;
                        ball0.yVelocity -= ay;
                        ball1.xVelocity += ax;
                        ball1.yVelocity += ay;
                    }
                }
            }
            
            for(i = 0; i < numBalls; i++) {
                var ball:Ball = balls[i];
                if (ball && ball != draggedBall) {
                    moveBall(ball);
                }
            }
        }
        
        private function onPress(event:MouseEvent):void {
            //ball.x = evt.localX;
            //ball.y = evt.localY;
            draggedBall = event.target as Ball;
            if (draggedBall != null) {
                draggedBall.startDrag();
            }
        }
        
        private function onRelease(event:MouseEvent):void {
            if (draggedBall != null) {
                draggedBall.stopDrag();
                draggedBall = null;
            }
        }
        
        private function moveBall(ball:Ball):void {
            ball.yVelocity += gravity;
            ball.x += ball.xVelocity;
            ball.y += ball.yVelocity;
            if(ball.x + ball.radius > stage.stageWidth)  {
                ball.x = stage.stageWidth - ball.radius;
                ball.xVelocity *= bounce;
            }
            else if(ball.x - ball.radius < 0) {
                ball.x = ball.radius;
                ball.xVelocity *= bounce;
            }
            if(ball.y + ball.radius > stage.stageHeight) {
                ball.y = stage.stageHeight - ball.radius;
                ball.yVelocity *= bounce;
            }
            else if(ball.y - ball.radius < 0) {
                ball.y = ball.radius;
                ball.yVelocity *= bounce;
            }
        }
    }
}
