package  com.becker.animation
{
    import com.becker.common.Ball;
    import com.becker.common.Segment;
    
    import flash.events.Event;
    import flash.geom.Point;
    
    import mx.core.UIComponent;

    /**
     * an articulated arm catches and throws a ball.
     */
    public class PlayBall extends UIComponent implements Animatible
    {
        private var segments:Array;
        private var numSegments:uint = 6;
        private var gravity:Number = 0.5;
        private var bounce:Number = -0.9;
        private var ball:Ball;
        
        public function PlayBall()
        {
        }
        
        public function startAnimating():void
        {
            ball = new Ball(20);
            ball.xVelocity = 10;
            addChild(ball);
            segments = new Array();
            for (var i:uint = 0; i < numSegments; i++)
            {
                var segment:Segment = new Segment(50, 10);
                addChild(segment);
                segments.push(segment);
            }
            segment.x = this.width / 2;
            segment.y = this.height;
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function onEnterFrame(event:Event):void
        {
            ball.bounce(bounce, gravity, this);
            var target:Point = reach(segments[0], ball.x, ball.y);
            for(var i:uint = 1; i < numSegments; i++)
            {
                var segment:Segment = segments[i];
                target = reach(segment, target.x, target.y);
            }
            for(i = numSegments - 1; i > 0; i--)
            {
                var segmentA:Segment = segments[i];
                var segmentB:Segment = segments[i - 1];
                position(segmentB, segmentA);
            }
            checkHit();
        }
        
        private function reach(segment:Segment, xpos:Number, ypos:Number):Point
        {
            var frontPin:Point = segment.frontConnector.getPosition();
            var dx:Number = xpos - frontPin.x;
            var dy:Number = ypos - frontPin.y;
            var angle:Number = Math.atan2(dy, dx);
            segment.rotation = angle * 180 / Math.PI;
            
            var rearPin:Point = segment.rearConnector.getPosition();
            var w:Number = rearPin.x - segment.x;
            var h:Number = rearPin.y - segment.y;
            var tx:Number = xpos - w;
            var ty:Number = ypos - h;
            return new Point(tx, ty);
        }
        
        private function position(segmentA:Segment, segmentB:Segment):void
        {
            var rearPinB:Point = segmentB.rearConnector.getPosition();
            segmentA.x = rearPinB.x;
            segmentA.y = rearPinB.y;
        }

        public function checkHit():void
        {
            var segment:Segment = segments[0];
            var rearPin:Point = segment.rearConnector.getPosition();
            var dx:Number = rearPin.x - ball.x;
            var dy:Number = rearPin.y - ball.y;
            var dist:Number = Math.sqrt(dx * dx + dy * dy);
            if(dist < ball.radius)
            {
                ball.xVelocity += Math.random() * 2 - 1;
                ball.yVelocity -= 1;
            }
        }
    }
}
