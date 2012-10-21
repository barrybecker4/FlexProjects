package com.becker.animation.sprites.support {
    import flash.events.TimerEvent;
    import flash.utils.Timer;
	/**
     * ...
     * @author Barry Becker
     */
    public class AmmoGenerator {
        
        /** default max bullets. Don't grow more than this. */
        private static const DEFAULT_MAX:uint = 20;
        
        /** add some more bullets every second */
        private static const DEFAULT_GENERATION_RATE:uint = 1000;
        
        /** number to add when the generation time fires */
        private static const DEFAULT_SPAWN_INC:uint = 1;
        
        /** current amount of amo. Must be 0 or more */
        private var _currentCount:int = 0;
        private var _max:uint = DEFAULT_MAX;
        private var _spawnIncrement:uint = DEFAULT_SPAWN_INC;
        
        /** timer fires at regular intervals corresponding to the generationRate */
        private var time_count:Timer;
        
        /**
         * 
         * @param initialAmount
         * @param generationRate
         */
        public function AmmoGenerator(initialAmount:uint = 0, 
                                      generationRate:Number = DEFAULT_GENERATION_RATE) {
            
            _currentCount = initialAmount;
            if (generationRate > 0) {
                time_count = new Timer(generationRate);
                time_count.addEventListener(TimerEvent.TIMER, createNewBullets);
                time_count.start();
            }
        }
        
        public function get currentBulletCount():uint {
            return _currentCount;
        }
        
        public function get maxBulletCount():uint {
            return _max;
        }
        
        public function set maxBulletCount(max:uint):void {
            _max = max;
        }
        
        /** If num is > 1 this could allow more bullets to be shot than we have */
        public function decrementCount(num:uint = 1):void {
            _currentCount -= num;
            if (_currentCount < 0) {
                _currentCount = 0;
            }
        }
        
        public function set spawnIncrement(inc:uint):void {
            _spawnIncrement = inc;
        }
        
        private function createNewBullets(event:TimerEvent):void {
            _currentCount += _spawnIncrement;
            if (_currentCount > _max) {
                _currentCount = _max;
            }
        }
    }
}