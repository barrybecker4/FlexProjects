package com.becker.animation.box2d.builders {
    
    import Box2D.Collision.Shapes.b2CircleShape;
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.Joints.b2DistanceJointDef;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import com.becker.animation.sprites.Line;
    import com.becker.common.PhysicalParameters;
    import com.becker.animation.box2d.builders.items.car.Car;
    import flash.geom.Point;
    import mx.core.UIComponent;
    
    /**
     * Build a car with manipulable parmeters
     */
    public class CarBuilder extends AbstractBuilder {
        
        private static const T_SCALE:Number = 4.0;
        private static const SIZE:Number = 2.0;
        private static const WHEEL_RADIUS:Number = 0.6;
        private static const AXLE_ANGLE:Number = Math.PI / 4;
        private static const MOTOR_SPEED:Number = -2.0;
        private static const MOTOR_TORQUE:Number = SIZE * 150.0;
        
        private var shapeBuilder:BasicShapeBuilder;
        private var params:PhysicalParameters;    
        
        private var car:Car;
        
    
        /** Constructor */
        public function CarBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
            shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        public function buildInstance(startX:Number, startY:Number, 
                                      params:PhysicalParameters):Car {           
            car = new Car();
                  
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            bodyDef.position.Set(startX, startY);
            
            createCarBody(bodyDef);
            createAxles(bodyDef);
            createWheels(bodyDef);
            createJoints(bodyDef);

            return car;
        }
    
        private function createCarBody(bodyDef:b2BodyDef):void {
            var blocks:Array = [
                new OrientedBox(SIZE * 1.5, SIZE * 0.3, new b2Vec2(0, 0), 0),
                new OrientedBox(SIZE * 0.4, SIZE * 0.15, new b2Vec2( -1 * SIZE, 0.3 * SIZE), -AXLE_ANGLE),
                new OrientedBox(SIZE * 0.4, SIZE * 0.15, new b2Vec2( 1 * SIZE, 0.3 * SIZE),  AXLE_ANGLE),
                new OrientedBox(SIZE * 0.4, SIZE * 0.1,  new b2Vec2(SIZE * ( -1 - 0.6 * Math.cos(AXLE_ANGLE)), SIZE * ( 0.3 + 0.6 * Math.sin(AXLE_ANGLE)) ),  -AXLE_ANGLE),
                new OrientedBox(SIZE * 0.4, SIZE * 0.1, new b2Vec2(SIZE * (1 + 0.6 * Math.cos( -AXLE_ANGLE)), SIZE * (0.3 - 0.6 * Math.sin( -AXLE_ANGLE))), AXLE_ANGLE)
            ];
            
            car.carBody = shapeBuilder.buildCompoundBlock(blocks, bodyDef, 2, 0.5, 0.2, -1); 
        }
        
        private function createAxles(bodyDef:b2BodyDef):void {
            var boxDef:b2FixtureDef = new b2FixtureDef();
            boxDef.density = 1.0;
            var prismaticJointDef:b2PrismaticJointDef = createPrismaticJoint();
            
            var orientedBox:OrientedBox = 
                new OrientedBox(SIZE * 0.4, SIZE * 0.1, 
                    new b2Vec2(SIZE * ( -1 - 0.6 * Math.cos(AXLE_ANGLE)), SIZE * ( 0.3 + 0.6 * Math.sin(AXLE_ANGLE)) ), 
                    -AXLE_ANGLE);
            car.axles[0] = shapeBuilder.buildCompoundBlock([orientedBox], bodyDef, 1.0);

            prismaticJointDef.Initialize(car.carBody, car.axles[0], car.axles[0].GetWorldCenter(), 
                                         new b2Vec2(Math.cos(-AXLE_ANGLE), Math.sin(-AXLE_ANGLE)));
     
            car.springs[0] = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint; 
            
            orientedBox = 
                new OrientedBox(SIZE * 0.4, SIZE * 0.1, 
                    new b2Vec2(SIZE * (1 + 0.6 * Math.cos( -AXLE_ANGLE)), SIZE * (0.3 - 0.6 * Math.sin( -AXLE_ANGLE))), 
                    AXLE_ANGLE);
            car.axles[1] = shapeBuilder.buildCompoundBlock([orientedBox], bodyDef, 1.0);

            prismaticJointDef.Initialize(car.carBody, car.axles[1], car.axles[1].GetWorldCenter(), 
                                         new b2Vec2(-Math.cos(-AXLE_ANGLE), Math.sin(-AXLE_ANGLE)));
     
            car.springs[1] = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
        }
        
        private function createPrismaticJoint():b2PrismaticJointDef {
            var prismaticJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
            prismaticJointDef.lowerTranslation = -0.3;
            prismaticJointDef.upperTranslation = 0.5;
            prismaticJointDef.enableLimit = true;
            prismaticJointDef.enableMotor = true;
            return prismaticJointDef;
        }
        
        private function createWheels(bodyDef:b2BodyDef):void {

            bodyDef.allowSleep = false;
     
            for (var i:int = 0; i < 2; i++) {
     
                if (i == 0) {
                    bodyDef.position.Set(car.axles[0].GetWorldCenter().x - SIZE * 0.3 * Math.cos(AXLE_ANGLE), 
                                         car.axles[0].GetWorldCenter().y + SIZE * 0.3 * Math.sin(AXLE_ANGLE));
                }
                else {
                    bodyDef.position.Set(car.axles[1].GetWorldCenter().x + SIZE * 0.3 * Math.cos( -AXLE_ANGLE), 
                                         car.axles[1].GetWorldCenter().y - SIZE * 0.3 * Math.sin( -AXLE_ANGLE));
                }
               
                car.wheels[i] = shapeBuilder.buildBall(SIZE * WHEEL_RADIUS, bodyDef, 0.2, 0.9, 0.2, -1);
            }
        }
        
        private function createJoints(bodyDef:b2BodyDef):void {
            
            var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
            revoluteJointDef.enableMotor = true;
     
            revoluteJointDef.Initialize(car.axles[0], car.wheels[0], car.wheels[0].GetWorldCenter());
            car.motors[0] = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
     
            revoluteJointDef.Initialize(car.axles[1], car.wheels[1], car.wheels[1].GetWorldCenter());
            car.motors[1] = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
             
            // Set motor speeds. belongs in update
            car.motors[0].SetMotorSpeed(1); // 5 * Math.PI * 0.5); 
            // (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
            car.motors[0].SetMaxMotorTorque(10); // Car.TORQUE_INC);
            // input.isPressed(40) || input.isPressed(38) ? 17 : 0.5);
     
            car.motors[1].SetMotorSpeed(1); // 5 * Math.PI * 0.5); 
            // (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
            car.motors[1].SetMaxMotorTorque(10); // Car.TORQUE_INC); 
            // input.isPressed(40) || input.isPressed(38) ? 12 : 0.5);
     
            // not sure what this stuff does yet
            car.springs[0].SetMaxMotorForce(30 + Math.abs(MOTOR_TORQUE * Math.pow(car.springs[0].GetJointTranslation(), 2)));
            car.springs[0].SetMotorSpeed((car.springs[0].GetMotorSpeed() - 10 * car.springs[0].GetJointTranslation()) * 0.4);         
     
            car.springs[1].SetMaxMotorForce(30 + Math.abs(MOTOR_TORQUE * Math.pow(car.springs[1].GetJointTranslation(), 2)));
            car.springs[1].SetMotorSpeed(-4 * Math.pow(car.springs[1].GetJointTranslation(), 1));
     
            car.carBody.ApplyTorque(100); // Car.TORQUE_INC); // 30 * (input.isPressed(37) ? 1: input.isPressed(39) ? -1 : 0));
        }
    }
}