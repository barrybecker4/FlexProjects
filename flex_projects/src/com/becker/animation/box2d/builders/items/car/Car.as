package com.becker.animation.box2d.builders.items.car {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    
    public class Car {
       
        private static const MAX_SPEED:Number = 40;
        private static const SPEED_INC:Number = 0.8;
        private static const MOTOR_TORQUE:Number = 400.0;
        
        public var carBody: b2Body;
        
        // @@ make WheellAssembly
        public var wheels  : Array = [];    // b2Body
        public var axles   : Array = [];    // b2Body
        public var motors  : Array = [];    // b2RevoluteJoint;
        public var springs : Array = [];    // b2PrismaticJoint;
        
        public var braking:Boolean = false;
        public var increaseAcceleration:Boolean = false;
        public var decreaseAcceleration:Boolean = false;
        
        private var motorSpeed:Number = 0.0;
        
        /** Constructor */
        public function Car() { };
        
        
        /** should be called on every frame up update the motor speed and torque */
        public function updateMotor():void {
            if (braking) {
                motorSpeed *= 0.8;
            }
            else {
                motorSpeed *=0.99;  // damping due to friction
            }
            
            if (increaseAcceleration) {
                motorSpeed += SPEED_INC;
            }
            else if (decreaseAcceleration) {
                motorSpeed -= SPEED_INC;
            }
            
            setMotorSpeed(motorSpeed);
            
            braking = false;
            increaseAcceleration = false;
            decreaseAcceleration = false;
        }
        
        public function updateShockAbsorbers():void {
            // not sure what this stuff does yet
            var spring:b2PrismaticJoint = springs[0];
            spring.SetMaxMotorForce(30 + Math.abs(MOTOR_TORQUE * Math.pow(spring.GetJointTranslation(), 2)));
            spring.SetMotorSpeed((spring.GetMotorSpeed() - 10 * spring.GetJointTranslation()) * 0.4);         
     
            spring = springs[1];
            spring.SetMaxMotorForce(30 + Math.abs(MOTOR_TORQUE * Math.pow(spring.GetJointTranslation(), 2)));
            spring.SetMotorSpeed(-4 * Math.pow(spring.GetJointTranslation(), 1));
     
            carBody.ApplyTorque(100); 
        }
        
        /** as speed increases, torque is reduced - like in an automatic trasmission. */
        private function setMotorSpeed(speed:Number):void  { 
            
            if (speed > MAX_SPEED) {
                 speed = MAX_SPEED;
            }
            
            var maxMotorTorque:Number = 10 * (MAX_SPEED + 2 - speed);
            
            // Set motor speeds. belongs in update
            motors[0].SetMotorSpeed(speed); 
            motors[0].SetMaxMotorTorque(maxMotorTorque);
     
            motors[1].SetMotorSpeed(speed); 
            motors[1].SetMaxMotorTorque(maxMotorTorque); 
            
            // trace("motor speed : " + speed +" maxTorque=" + maxMotorTorque);
        }
       
    }
}