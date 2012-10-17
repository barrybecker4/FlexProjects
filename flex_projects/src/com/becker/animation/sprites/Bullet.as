package com.becker.animation.sprites {
    
    import com.becker.animation.box2d.builders.items.Cannon;
    import flash.utils.Timer;
    
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    
    /**
     * Bullet shot from cannon
     * 
     * @author Barry Becker
     */
    public class Bullet extends Circle {
        
        /** The bullet will be removed after this amount of time */
        private static const BULLET_DURATION:uint = 4000;
        
        /** setting the time to 10,000 milliseconds = 10 seconds */
        public var time_count:Timer = new Timer(BULLET_DURATION);
        
        /**  flag to determine if I have to remove the bullet */
        public var remove:Boolean = false;
        
        /** Constructor */
        public function Bullet(radius:Number = 0.5) {
            super(radius);
            this.name = Cannon.BULLET;
            
            time_count.addEventListener(TimerEvent.TIMER, isOld);
            time_count.start();
        }
     
        /**
         * removing the time listener and setting the flag to true
         * @param event timer event
         */
        public function isOld(event:TimerEvent):void {
            time_count.removeEventListener(TimerEvent.TIMER, isOld);
            remove = true;
        }
        
        /** returning the flag, this is the method I'll call from the main class */
        public function isToBeRemoved():Boolean {
            return (remove);
        }
    }
}