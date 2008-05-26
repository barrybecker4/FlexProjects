package com.becker.animation 
{
    import com.becker.animation.threed.Ball3D;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.core.UIComponent;
        
    public class Fireworks extends UIComponent implements Animatible
    {
        private var balls:Array;
        private var numBalls:uint = 50;
        private var fl:Number = 200; // 250 
        private var vpX:Number;
        private var vpY:Number;
        private var gravity:Number = 0.2;
        private var floor:Number = 200;
        private var bounce:Number = -0.6;
        
        public function Fireworks() {}
        
        public function startAnimating():void
        {    
            vpX = this.width / 2;
            vpY = this.height / 2;        
            balls = new Array();    
            burstInit(vpX, vpY);    
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            parent.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        }
        
        private function mouseDown(evt:MouseEvent):void
        {            
            burstInit(mouseX, mouseY);
        }
        
        private function burstInit(xpos:int, ypos:int):void
        {
            var halfWidth:int = this.width/2;
            var halfHeight:int = this.height/2;
            
            for(var i:uint = 0; i < numBalls; i++)
            {
                var ball:Ball3D = new Ball3D(5, Math.random() * 0xffffff);
                balls.push(ball);
                ball.ypos = -100;
                ball.xpos = xpos - halfWidth;
                ball.ypos = ypos - halfHeight;
                ball.vx = Math.random() * 6 - 3;
                ball.vy = Math.random() * 6 - 6;
                ball.vz = Math.random() * 6 - 3;
                addChild(ball);
            }
        }
        
        private function onEnterFrame(event:Event):void
        {
            for(var i:uint = 0; i < balls.length; i++)
            {
                var ball:Ball3D = balls[i];
                moveBall(ball);
            }
            sortZ();
        }
        
        private function moveBall(ball:Ball3D):void
        {
            var radius:Number = ball.radius;
            
            ball.vy += gravity;
            ball.xpos += ball.vx;
            ball.ypos += ball.vy;
            ball.zpos += ball.vz;
            
            if(ball.ypos > floor)
            {
                ball.ypos = floor;
                ball.vy *= bounce;
            }
            
            if(ball.zpos > -fl)
            {
                var scale:Number = fl / (fl + ball.zpos);
                ball.scaleX = ball.scaleY = scale;
                ball.x = vpX + ball.xpos * scale;
                ball.y = vpY + ball.ypos * scale;
                ball.visible = true;
            }
            else
            {
                ball.visible = false;
            }
        }
        
        private function sortZ():void
        {
            balls.sortOn("zpos", Array.DESCENDING | Array.NUMERIC);
            for(var i:uint = 0; i < balls.length; i++)
            {
                var ball:Ball3D = balls[i];
                setChildIndex(ball, i);
            }
        }
    }
}
