package com.becker.animation.box2d.builders {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import com.becker.animation.box2d.builders.items.car.Car;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
    
    /**
     * Build a parameterized car 
     */
    public class CarBuilder extends AbstractBuilder {
        
        private static const SIZE:Number = 2.5;
        
        private static const BODY_WIDTH:Number = 1.6;
        private static const BODY_HEIGHT:Number = 0.3;
        private static const SHOCK_DISTANCE:Number = 1.6;
        private static const SHOCK_WIDTH:Number = 0.16;
        private static const SHOCK_HEIGHT:Number = 0.5;
        private static const SHOCK_DEPTH:Number = 0.1;
        private static const WHEEL_RADIUS:Number = 0.6;
        private static const AXLE_ANGLE:Number = Math.PI / 4;
        
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

        /** Create a compound body for all the fixed car parts. */
        private function createCarBody(bodyDef:b2BodyDef):void {
            var blocks:Array = [
                new OrientedBox(SIZE * BODY_WIDTH, SIZE * BODY_HEIGHT, new b2Vec2(0, 0), 0),
                new OrientedBox(SIZE * SHOCK_WIDTH, SIZE * SHOCK_HEIGHT, 
                    new b2Vec2( -SHOCK_DISTANCE * SIZE, SHOCK_DEPTH * SIZE), AXLE_ANGLE),
                new OrientedBox(SIZE * SHOCK_WIDTH, SIZE * SHOCK_HEIGHT, 
                    new b2Vec2( SHOCK_DISTANCE * SIZE, SHOCK_DEPTH * SIZE),  -AXLE_ANGLE),
            ];
            
            car.carBody = shapeBuilder.buildCompoundBlock(blocks, bodyDef, 2, 0.5, 0.2, -1); 
        }
        
        private function createAxles(bodyDef:b2BodyDef):void {
            
            car.axles[0] =  createAxle(1, bodyDef);
            car.axles[1] =  createAxle(-1, bodyDef);
                               
            var boxDef:b2FixtureDef = new b2FixtureDef();
            boxDef.density = 1.0;
            var prismaticJointDef:b2PrismaticJointDef = createPrismaticJoint();
            prismaticJointDef.Initialize(car.carBody, car.axles[0], car.axles[0].GetWorldCenter(), 
                                         new b2Vec2(Math.cos(-AXLE_ANGLE), Math.sin(-AXLE_ANGLE)));
     
            car.springs[0] = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint; 
            prismaticJointDef.Initialize(car.carBody, car.axles[1], car.axles[1].GetWorldCenter(), 
                                         new b2Vec2(-Math.cos(-AXLE_ANGLE), Math.sin(-AXLE_ANGLE)));
     
            car.springs[1] = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
        }
        
        private function createAxle(sign:Number, bodyDef:b2BodyDef):b2Body {
        
            var center:b2Vec2 = car.carBody.GetWorldCenter();
            var ang:Number = sign * AXLE_ANGLE;
            bodyDef.position.Set(
                center.x + SIZE * -sign * ( SHOCK_DISTANCE + SHOCK_HEIGHT * Math.cos(ang)), 
                center.y + SIZE * (SHOCK_DEPTH + sign * SHOCK_HEIGHT * Math.sin(ang)));
            bodyDef.angle = ang;
            return shapeBuilder.buildBlock(SIZE * SHOCK_WIDTH / 2.0, 
                                           SIZE * SHOCK_HEIGHT, bodyDef, 
                                           1.0, 0.5, 0.0, -1); 
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
     
                var sign:Number = (i == 0) ? 1: -1;
                var center:b2Vec2 = car.axles[i].GetWorldCenter();
                
                bodyDef.position.Set(center.x - sign * SIZE * 0.3 * Math.cos(sign * AXLE_ANGLE), 
                                     center.y + sign * SIZE * 0.3 * Math.sin(sign * AXLE_ANGLE));

                car.wheels[i] = shapeBuilder.buildBall(SIZE * WHEEL_RADIUS, bodyDef, 0.2, 1.1, 0.2, -1);
            }
        }
        
        private function createJoints(bodyDef:b2BodyDef):void {
            
            var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
            revoluteJointDef.enableMotor = true;
     
            revoluteJointDef.Initialize(car.axles[0], car.wheels[0], car.wheels[0].GetWorldCenter());
            car.motors[0] = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
     
            revoluteJointDef.Initialize(car.axles[1], car.wheels[1], car.wheels[1].GetWorldCenter());
            car.motors[1] = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
             
            // Set initial motor speeds.
            car.motors[0].SetMotorSpeed(1); 
            car.motors[0].SetMaxMotorTorque(10); 
     
            car.motors[1].SetMotorSpeed(1);  
            car.motors[1].SetMaxMotorTorque(10);  
        }
    }
}