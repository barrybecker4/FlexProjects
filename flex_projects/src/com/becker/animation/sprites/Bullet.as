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
        private static const BULLET_DURATION:uint = 5000;
        
        /** setting the time to 10,000 milliseconds = 10 seconds */
        public var time_count:Timer = new Timer(10000);
        
        /**  flag to determine if I have to remove the bullet */
        public var remove_the_bullet:Boolean = false;
        
        /** Constructor */
        public function Bullet(radius:Number = 0.5) {
            super(radius);
            this.name = Cannon.BULLET;
            
            time_count.addEventListener(TimerEvent.TIMER, bullet_is_old);
            time_count.start();
        }
     
        /**
         * removing the time listener and setting the flag to true
         * @param	event
         */
        public function bullet_is_old(event:TimerEvent):void {
            time_count.removeEventListener(TimerEvent.TIMER, bullet_is_old);
            remove_the_bullet = true;
        }
        
        /** returning the flag, this is the method I'll call from the main class */
        public function has_to_be_removed():Boolean {
            return (remove_the_bullet);
        }
    }
}