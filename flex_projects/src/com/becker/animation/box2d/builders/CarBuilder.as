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
    import flash.geom.Point;
    import mx.core.UIComponent;
    
    /**
     * Build a car with manipulable parmeters
     */
    public class CarBuilder extends AbstractBuilder {
        
        private static const T_SCALE:Number = 4.0;
        private static const MOTOR_SPEED:Number = -2.0;
        private static const MOTOR_TORQUE:Number = 400.0;
        
        private var shapeBuilder:BasicShapeBuilder;
        private var params:PhysicalParameters;    
        
        // temporary variables for adding new bodies 
        private var boxDef: b2FixtureDef;
        private var circleDef: b2FixtureDef;
        private var revoluteJointDef: b2RevoluteJointDef;
        private var prismaticJointDef: b2PrismaticJointDef;
        private var car:Car;
        
    
        /** Constructor */
        public function CarBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
            shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        
        public function buildInstance(startX:Number, startY:Number, 
                                      params:PhysicalParameters):Car {           
            
            car = new Car();
                  
            // add cart //
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
                new OrientedBox(1.5, 0.3, new b2Vec2(0, 0), 0),
                new OrientedBox(0.4, 0.15, new b2Vec2( -1, -0.3), Math.PI / 3),
                new OrientedBox(0.4, 0.15, new b2Vec2( 1, -0.3), -Math.PI / 3)
            ];
            
            car.carBody = shapeBuilder.buildCompoundBlock(blocks, bodyDef, 2, 0.5, 0.2, -1); //world.CreateBody(bodyDef);
        }
        
        private function createAxles(bodyDef:b2BodyDef):void {
            boxDef = new b2FixtureDef();
            boxDef.density = 1;
            
            car.axles[0] = world.CreateBody(bodyDef);
     
            var poly:b2PolygonShape = new b2PolygonShape();
            poly.SetAsOrientedBox(0.4, 0.1, new b2Vec2(-1 - 0.6*Math.cos(Math.PI/3), -0.3 - 0.6*Math.sin(Math.PI/3)), Math.PI/3);
            boxDef.shape = poly;
            
            car.axles[0].CreateFixture(boxDef);
            car.axles[0].ResetMassData();
     
            prismaticJointDef = new b2PrismaticJointDef();
            prismaticJointDef.Initialize(car.carBody, car.axles[0], car.axles[0].GetWorldCenter(), new b2Vec2(Math.cos(Math.PI/3), Math.sin(Math.PI/3)));
            prismaticJointDef.lowerTranslation = -0.3;
            prismaticJointDef.upperTranslation = 0.5;
            prismaticJointDef.enableLimit = true;
            prismaticJointDef.enableMotor = true;
     
            car.springs[0] = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
     
     
            car.axles[1] = world.CreateBody(bodyDef);
            
            poly = new b2PolygonShape();
            poly.SetAsOrientedBox(0.4, 0.1, new b2Vec2(1 + 0.6 * Math.cos( -Math.PI / 3), -0.3 + 0.6 * Math.sin( -Math.PI / 3)), -Math.PI / 3);
            boxDef.shape = poly;
            
            car.axles[1].CreateFixture(boxDef);
            car.axles[1].ResetMassData();
     
            prismaticJointDef.Initialize(car.carBody, car.axles[1], car.axles[1].GetWorldCenter(), new b2Vec2(-Math.cos(Math.PI/3), Math.sin(Math.PI/3)));
     
            car.springs[1] = world.CreateJoint(prismaticJointDef) as b2PrismaticJoint;
        }
        
        private function createWheels(bodyDef:b2BodyDef):void {

            circleDef = new b2FixtureDef();
            circleDef.density = 0.1;
            circleDef.friction = 5;
            circleDef.restitution = 0.2;
            circleDef.filter.groupIndex = -1;
            circleDef.shape = new b2CircleShape(0.7);
     
            for (var i:int = 0; i < 2; i++) {
     
                if (i == 0) {
                    bodyDef.position.Set(car.axles[0].GetWorldCenter().x - 0.3 * Math.cos(Math.PI / 3), car.axles[0].GetWorldCenter().y - 0.3 * Math.sin(Math.PI / 3));
                }
                else {
                    bodyDef.position.Set(car.axles[1].GetWorldCenter().x + 0.3 * Math.cos( -Math.PI / 3), car.axles[1].GetWorldCenter().y + 0.3 * Math.sin( -Math.PI / 3));
                }
                bodyDef.allowSleep = false;
     
                car.wheels[i] = world.CreateBody(bodyDef);
                car.wheels[i].CreateFixture(circleDef);
                car.wheels[i].ResetMassData();
            }
        }
        
        private function createJoints(bodyDef:b2BodyDef):void {
            
            revoluteJointDef = new b2RevoluteJointDef();
            revoluteJointDef.enableMotor = true;
     
            revoluteJointDef.Initialize(car.axles[0], car.wheels[0], car.wheels[0].GetWorldCenter());
            car.motors[0] = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
     
            revoluteJointDef.Initialize(car.axles[1], car.wheels[1], car.wheels[1].GetWorldCenter());
            car.motors[1] = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
             
            // Set motor speeds. belongs in update
            car.motors[0].SetMotorSpeed(10 * Math.PI * 0.5); // (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
            car.motors[0].SetMaxMotorTorque(12);// input.isPressed(40) || input.isPressed(38) ? 17 : 0.5);
     
            car.motors[1].SetMotorSpeed(10 * Math.PI * 0.5); // (input.isPressed(40) ? 1 : input.isPressed(38) ? -1 : 0));
            car.motors[1].SetMaxMotorTorque(12); // input.isPressed(40) || input.isPressed(38) ? 12 : 0.5);
     
            car.springs[0].SetMaxMotorForce(30 + Math.abs(800*Math.pow(car.springs[0].GetJointTranslation(), 2)));
            //car.spring1.SetMotorSpeed(-4*Math.pow(spring1.GetJointTranslation(), 1));
            car.springs[0].SetMotorSpeed((car.springs[0].GetMotorSpeed() - 10*car.springs[0].GetJointTranslation())*0.4);         
     
            car.springs[1].SetMaxMotorForce(20+Math.abs(800*Math.pow(car.springs[1].GetJointTranslation(), 2)));
            car.springs[1].SetMotorSpeed(-4*Math.pow(car.springs[1].GetJointTranslation(), 1));
     
            car.carBody.ApplyTorque(30); // 30 * (input.isPressed(37) ? 1: input.isPressed(39) ? -1 : 0));
        }
    }
}