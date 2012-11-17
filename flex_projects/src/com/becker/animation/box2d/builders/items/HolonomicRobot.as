package com.becker.animation.box2d.builders.items {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Common.Math.b2Vec3;
    import Box2D.Dynamics.b2Body;
    import com.becker.common.Matrix3;
    import flash.geom.Matrix;
    
    /**
     * Input will be the motor forces on each of the three wheels.
     * Output will be the cartesian and angular forces to apply to the body. 
     */
    public class HolonomicRobot {
        
        private static const MAX_POWER:Number = 20;
        private var _body:b2Body;
        
        /** uniformly spaced wheels starting at angle 0. */
        private var _numWheels:int;
        
        private var _power:Array;
      
        
        public function HolonomicRobot(body:b2Body, numWheels:int) {
                    
             _body = body;
             _numWheels = numWheels;
             _power = [];
             for (var i:int = 0; i < numWheels; i++) {
                 _power.push(Number(0));
             }
        }

        public function get body():b2Body {
            return _body;
        }        

        public function getWheelAngle(i:int):Number {
            return i * 360.0 / _numWheels;
        } 
        
        public function changePowerForWheel(i:int, powerDelta:Number):void {
            _power[i] += powerDelta;
            if (_power[i] > MAX_POWER) {
                _power[i] = MAX_POWER;
            }
            else if (_power[i] < -MAX_POWER) {
                _power[i] = -MAX_POWER;
            }
        }
        
        public function getPowerForWheel(i:int):Number {
            return _power[i];
        }
        
        /**
         * //@param currentAngle the current angle of the robots body.
         * Update the current forces  acting on the robot bodyas a vector where the first two entry 
         *     give the cartesian x, y components of the force and the third entry is the torque.
         */
        public function updateForces():void {
            
            var currentAngle:Number = body.GetAngle();
            //trace("ang = " + currentAngle + "Power A="+ getPowerForWheel(0) + " B="+ getPowerForWheel(1) + " C=" + getPowerForWheel(2));
            
            var C:Matrix3 = new HolonomicMatrix(currentAngle);
            var wheelForces:b2Vec3 = new b2Vec3(getPowerForWheel(0), getPowerForWheel(1), getPowerForWheel(2));
            
            var forces:b2Vec3 = C.MultVec(wheelForces);
            //trace("forces = " + forces.x + ", "+ forces.y + ", "+ forces.z);
            
            body.ApplyImpulse(new b2Vec2(forces.x, forces.y), body.GetWorldCenter());
            body.ApplyTorque(forces.z); 
        }
        
    }
}