package com.becker.animation.sprites {
    
    import flash.display.Sprite;
    
    /**
     * Represents a bazooka
     * @author Barry Becker
     */
    public class Bazooka extends AbstractShape {
        
        private static const MAX_CHARGE:Number = 50;
        private static const CHARGE_BAR_COLOR:int = 0xff1100;
        
        /** defining the power of the bazooka */
        private var _power:Number = 1;
        
        /**
         * flag to determine if I am charging the bazooka
         *  0 = not charging
         *  1 = positive charge
         * -1 = negative charge
         */
        private var charging:Number= 0;
        
        /** color when not charged */
        private var baseColor:uint;
        
        
        public function Bazooka(width:Number, height:Number, color:uint = 0x005533) {
            super(color)
            this.width = width;
            this.height = height;
            this.baseColor = color;
        }
        
        public function reset():void {
            charging = 0;
            _power = 1;
            invalidateDisplayList();
        }
        
        public function startCharging():void {
            charging = 1.0;
        }
        
        public function get power():int {
            return _power;
        }
        
        public function update():void {
            
             // If charging the bazooka (holding the mouse)
            if (charging != 0) {
                // update the power
                _power += charging;
               
                if (_power > MAX_CHARGE || _power <1) {
                    _power = MAX_CHARGE;
                } 
                this.invalidateDisplayList();
            }
        }
   
        override protected function updateDisplayList(w:Number, h:Number):void {
            super.updateDisplayList(w, h);
            
            graphics.lineStyle(0.5);
            graphics.beginFill(baseColor, 1.0);
            graphics.drawRect(-width/2.0, -height/2.0, width, height);
            graphics.endFill();  
            
            // now draw charge thermometer
            var ratio:Number = _power / MAX_CHARGE;
            graphics.beginFill(CHARGE_BAR_COLOR, 1.0);
            graphics.drawRect(-width/4.0, -height/2.0, width/2.0, ratio * height);
            graphics.endFill();  
        }
    }

}