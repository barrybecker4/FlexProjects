package  com.becker.animation.demos {
    import com.becker.animation.Animatible;
    import com.becker.animation.threed.*;
    import com.becker.common.Util;
    
    import flash.events.Event;
    
    import mx.core.UIComponent;

    public class MultiBounce3D extends UIComponent 
                               implements Animatible {
                                   
        private static const ROOM_SIZE:int = 170;
        private static const BOUNCE:Number = 1.0;
        private static const GRAVITY:Number = 2.0;
        private var balls:Array;
        private var numBalls:uint = 100;
        private var clip:ClippingPlane;        
        private var room:Room;
        
        
        public function MultiBounce3D() {            
            room = new Room(ROOM_SIZE);            
        }
        
        public function startAnimating():void  {
            clip = new ClippingPlane(450, this.width / 2, this.height / 2);
            
            balls = new Array();
            for (var i:uint = 0; i < numBalls; i++)  {
                var ball:Ball3D = new Ball3D(15, Util.getRandomColor());
                balls.push(ball);
                ball.vx = Math.random() * 10 - 5;
                ball.vy = Math.random() * 10 - 5;
                ball.vz = Math.random() * 10 - 5;
                addChild(ball);
            }
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        /** called for every frame refresh */
        private function onEnterFrame(event:Event):void {
            
            for (var i:uint = 0; i < numBalls; i++) {
                var ball:Ball3D = balls[i];
                ball.bounce(BOUNCE, GRAVITY, room, clip);
            }
        }

    }
}
