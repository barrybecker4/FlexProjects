package com.becker.animation.sprites {
    
    import com.becker.animation.box2d.builders.items.*;
    import flash.utils.Timer;
    
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    
    /**
     * Bullet shot from cannon
     * 
     * @author Barry Becker
     */
    public class Bullet extends Circle {
        
        /** The bullet will be removed after this amount of time by default */
        private static const DEFAULT_BULLET_DURATION:uint = 8000;
        
        /** timer fires at regular intervals corresponding to the generationRate  */
        private var time_count:Timer;
        
        /**  flag to determine if I have to remove the bullet */
        public var remove:Boolean = false;
        
        /** lifetime of the bullt. Forever if 0.  */
        private var duration:uint;
        
        /** 
         * Constructor 
         * @param radius size of the bullet
         * @param duration amount of time the bullet will persis for. if 0, then lasts forever.
         */
        public function Bullet(radius:Number = 0.5, 
                               duration:uint = DEFAULT_BULLET_DURATION) {
            super(radius);
            this.name = Cannon.BULLET;
            this.duration = duration;
            if (duration > 0) {
                time_count = new Timer(duration);
                time_count.addEventListener(TimerEvent.TIMER, isOld);
                time_count.start();
            }
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