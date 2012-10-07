package com.becker.animation.box2d.builders.items.car {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    
    public class Car {
       
        private static const MAX_SPEED:Number = 40;
        
        public var carBody: b2Body;
        
        // @@ make WheellAssembly
        public var wheels  : Array = [];    // b2Body
        public var axles   : Array = [];    // b2Body
        public var motors  : Array = [];    // b2RevoluteJoint;
        public var springs : Array = [];    // b2PrismaticJoint;
        
        private var transmission:Transmission = new Transmission();
     
        public function Car() { };
        
        public function setGear(gearIndex:int):void {
            transmission.setGearIndex(gearIndex);
        }
        
        /** as speed increases, torque is reduced - like in an automatic trasmission. */
        public function setMotorSpeed(speed:Number):void  { 
            
            if (speed > MAX_SPEED) {
                 speed = MAX_SPEED;
            }
            
            var maxMotorTorque:Number = 5 * (MAX_SPEED + 1 - speed);
            
            // Set motor speeds. belongs in update
            motors[0].SetMotorSpeed(speed); 
            
            // (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
            
            motors[0].SetMaxMotorTorque(maxMotorTorque);
            // input.isPressed(40) || input.isPressed(38) ? 17 : 0.5);
     
            motors[1].SetMotorSpeed(speed); 
            // (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
            
            motors[1].SetMaxMotorTorque(maxMotorTorque); 
            // input.isPressed(40) || input.isPressed(38) ? 12 : 0.5);
            
            // trace("motor speed : " + speed +" maxTorque=" + maxMotorTorque);
        }
        
        
        /**
         * Constructor
         *
        public function Car(carBody:b2Body, wheel1:b2Body, wheel2:b2Body,
            axle1:b2Body, axle2:b2Body, motor1:b2RevoluteJoint, motor2:b2RevoluteJoint,
            spring1:b2PrismaticJoint, spring2:b2PrismaticJoint) {
  
            _carBody = carBody;
            _wheel1 = wheel;
            _wheel2 = wheel2;
            _axle1 = axle1;
            _axle2 = axle2;
            _motor1 = motor1;
            _motor2 = _motor2;
            _spring1 = spring1;
            _spring2 = spring2;

        }*/

        /*
        public function get carBody():b2Body {
            return _carBody;
        }   
        
        public function get wheel1():b2Body {
            return _wheel1;
        }   
        
        public function get wheel2():b2Vec2 {
            return _wheel2;
        } */
        
    }
}