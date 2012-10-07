package com.becker.animation.box2d.builders.items.car {
	/**
     * ...
     * @author Barry Becker
     */
    public class Gear {
        
        private var _gear:int
        private var _label:String;
        private var _torque:int;
        private var _speed:int;
        
        /**
         * Constructor
         * @param	gear something like -1, 0, 1, 2, ...
         * @param	label What the gear is to be called. e.g. "reverse", "low", "3", etc.
         * @param	torque power
         * @param	speed angular velocity
         */
        public function Gear(gear:int, label:String, torque:uint, speed:int) {
            
            _gear = gear;
            _label = label;
            _torque = torque;
            _speed = speed;
        }
        
        public function get gear():int {
            return _gear;
        }
        
        public function get label():String {
            return _label;
        }
        
        public function get torque():uint {
            return _torque;
        }
        
        public function get speed():int {
            return _speed;
        }
    }

}