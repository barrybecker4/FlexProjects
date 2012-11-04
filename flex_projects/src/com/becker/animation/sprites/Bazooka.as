package com.becker.animation.sprites {
    
    import com.becker.animation.sprites.support.AmmoGenerator;
    import flash.display.Sprite;
    import flash.events.Event;
    
    /**
     * Represents a bazooka
     * @author Barry Becker
     */
    public class Bazooka extends AbstractShape {
        
        private static const DEFAULT_MAX_CHARGE:Number = 20;
        private static const CHARGE_BAR_COLOR:int = 0xff1100;
        private static const BULLET_BAR_COLOR:int = 0x33cc88;
        private static const INITIAL_NUM_BULLETS:uint = 20;
        private static const BULLET_SPAWN_INC:uint = 2;
        
        /** defining the power of the bazooka */
        private var _charge:Number = 0.5;
        private var _maxCharge:Number = DEFAULT_MAX_CHARGE;
        
        /**
         * flag to determine if I am charging the bazooka
         *  0 = not charging
         *  1 = positive charge
         * -1 = negative charge
         */
        private var charging:Number= 0;
        
        /** color when not charged */
        private var baseColor:uint;
        
        private var ammoGenerator:AmmoGenerator;
        
        
        /**
         * Constructor
         * @param	width
         * @param	height
         * @param	color
         */
        public function Bazooka(width:Number, height:Number, color:uint = 0x005533) {
            super(color)
            this.width = width;
            this.height = height;
            this.baseColor = color;
            ammoGenerator = new AmmoGenerator(INITIAL_NUM_BULLETS, 2000);
            ammoGenerator.spawnIncrement = BULLET_SPAWN_INC;
            ammoGenerator.eventDispatcher.addEventListener(AmmoGenerator.AMMO_CREATED, ammoCreated, false, 0, true);
            trace("in bazook a constructor");
        }
        
        public function set charge(c:Number):void {
            _charge = c;
        }
        
        public function get charge():Number {
            return _charge * _charge;
        }
        
        public function set maxCharge(mc:Number):void {
            _maxCharge = mc;
        }
        
        public function discharged():void {
            charging = 0;
            _charge = 1;
            ammoGenerator.decrementCount();
            invalidateDisplayList();
        }
        
        public function startCharging():void {
            charging = 0.8;
        }
        
        public function get hasBullets():Boolean {
            return (ammoGenerator.currentBulletCount > 0);
        }
        
        private function ammoCreated(event:Event):void {
            invalidateDisplayList();
        }
        
        public function update():void {
            
             // If charging the bazooka and we have ammo to shoot
            if (charging != 0 && ammoGenerator.currentBulletCount > 0) {
                // update the power
                _charge += charging;
                //updateDisplayList(width, height);
               
                if (_charge > _maxCharge) {
                    _charge = _maxCharge;
                }
            }
        }
     
        
        override protected function updateDisplayList(w:Number, h:Number):void {
            
            var halfHeight:Number = height / 2.0;
            graphics.lineStyle(0.5);
            graphics.beginFill(baseColor, 1.0);
            graphics.drawRect(-width/2.0, -halfHeight, width, height);
            graphics.endFill();  

            // draw indicator for remaining ammo
            var bulletRatio:Number = 
                Number(ammoGenerator.currentBulletCount) / Number(ammoGenerator.maxBulletCount);
            graphics.beginFill(BULLET_BAR_COLOR, 1.0);
            graphics.drawRect(-width/3.0, -halfHeight, 2.0*width/3.0, bulletRatio * height);
            graphics.endFill();  
            
            // draw charge thermometer
            var ratio:Number = _charge / _maxCharge;
            graphics.beginFill(CHARGE_BAR_COLOR, 1.0);
            graphics.drawRect(-width/4.0, -halfHeight, width/2.0, ratio * height);
            graphics.endFill(); 
            
            //trace("numQueuedUpdates=" + numQueuedUpdates);
            super.updateDisplayList(w, h);
        }
    }

}