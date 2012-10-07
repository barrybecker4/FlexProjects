package com.becker.animation.box2d.builders.items.car {
	/**
     * Represents a cars transmission.
     * Lower gears have more torque but lower speeds.
     * @author Barry Becker
     */
    public class Transmission {
        
        private var gearIndex:int;
            
        private static const table:Array = [
            new Gear(-1, "R", 500, 10),
            new Gear(0, "N", 1, 0),
            new Gear(1, "1", 500, 10),
            new Gear(2, "2", 400, 20),
            new Gear(3, "3", 300, 35),
            new Gear(4, "4", 200, 50)
        ];
        
        public function Transmission() { }
        
        /** Select a gear */
        public function setGearIndex(gear:int):void {
            gearIndex = gear;
        }
        
        public function getGear():Gear {
            return table[gearIndex];
        }
        
    }

}