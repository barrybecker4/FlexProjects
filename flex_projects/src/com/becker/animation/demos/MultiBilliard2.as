package com.becker.animation.demos
{
    import com.becker.animation.Animatible;
    import com.becker.common.Ball;
    import com.becker.common.Util;
    
    import flash.events.Event;
    import flash.geom.Point;
    
    import mx.core.UIComponent;

    public class MultiBilliard2 extends UIComponent implements Animatible
    {
        private var balls:Array;
        private var numBalls:uint = 50;
        private var bounce:Number = -1.0;
        
        public function MultiBilliard2()
        {}
        
        public function startAnimating():void
        {
            
            balls = new Array();
            for (var i:uint = 0; i < numBalls; i++)
            {
                var radius:Number = Math.random() * 40 + 10;
                var ball:Ball = new Ball(radius);
                ball.mass = radius;
                ball.x = Math.random() * this.width;
                ball.y = Math.random() * this.height;
                ball.xVelocity = Math.random() * 20 - 5;
                ball.yVelocity = Math.random() * 20 - 5;
                addChild(ball);
                balls.push(ball);
            }

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function onEnterFrame(event:Event):void
        {
            for(var i:uint = 0; i < numBalls; i++)
            {
                var ball:Ball = balls[i];
                ball.x += ball.xVelocity;
                ball.y += ball.yVelocity;
                ball.bounce(0, bounce, this);
                
            }
            for(i = 0; i < numBalls - 1; i++)
            {
                var ballA:Ball = balls[i];
                for(var j:Number = i + 1; j < numBalls; j++)
                {
                    var ballB:Ball = balls[j];
                    ballA.handleCollision(ballB);
                }
            }
        }
        
    }
}