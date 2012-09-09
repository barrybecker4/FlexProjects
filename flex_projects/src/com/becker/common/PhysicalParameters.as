package com.becker.common 
{
    /**
     * Collection of parameters for physical objects
     * @author Barry Becker
     */
    public class PhysicalParameters  {
        
        private var _density:Number;
        private var _friction:Number;
        private var _restitution:Number;
        
        /**
         * Constructor
         * @param density mass divided by volume
         * @param friction coeeficient of friction
         * @param restitution ability to bounce back
         */
        public function PhysicalParameters(density:Number, friction:Number, restitution:Number)  {
           _density = density;
           _friction = friction;
           _restitution = restitution;
        }
        
        public function get density():Number {
            return _density;
        }
        
        public function get friction():Number {
            return _friction;
        }
        
        public function get restitution():Number {
            return _restitution;
        }
        
    }

}