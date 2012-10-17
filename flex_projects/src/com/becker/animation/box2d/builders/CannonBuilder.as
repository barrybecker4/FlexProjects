package com.becker.animation.box2d.builders {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2ContactListener;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import com.becker.animation.box2d.builders.items.Cannon;
    import com.becker.animation.sprites.Bazooka;
    import com.becker.animation.sprites.Rectangle;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
    
    /**
     * Build a cannon with manipulable parameters
     */
    public class CannonBuilder extends AbstractBuilder {
        
        private static const SIZE:Number = 2.5;
        private static const PLAYER_WIDTH:Number = 1.0;
        private static const PLAYER_HEIGHT:Number = 2.0;
        
        private static const ZOOKA_WIDTH:Number = 0.3;
        private static const ZOOKA_HEIGHT:Number = 1.2;

        private var shapeBuilder:BasicShapeBuilder;
        private var params:PhysicalParameters;    
        
    
        /** Constructor */
        public function CannonBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
            shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        public function buildInstance(startX:Number, startY:Number, 
                                      params:PhysicalParameters):Cannon {
 
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            bodyDef.position.Set(startX, startY);
            
            var cannonBody:b2Body = 
                shapeBuilder.buildBlock(PLAYER_WIDTH, PLAYER_HEIGHT, bodyDef, params.density, params.friction, params.restitution, 1);
            cannonBody.GetUserData().name = Cannon.PLAYER;
            
            var zookaPos:b2Vec2 = new b2Vec2(startX, startY - PLAYER_HEIGHT - ZOOKA_HEIGHT/2.0);
            var bazooka:b2Body = createAttachedBazooka(zookaPos, bodyDef, cannonBody);
            
            var ground_sensor:b2FixtureDef = createGroundSensor(bodyDef);
            
            var contactListener:CannonContactListener = new CannonContactListener();
            world.SetContactListener(contactListener);

            return new Cannon(cannonBody, bazooka, ground_sensor, contactListener);
        }
        
        private function createAttachedBazooka(zookaPos:b2Vec2, bodyDef:b2BodyDef, cannonBody:b2Body):b2Body {
            
            bodyDef.position = zookaPos;  
            //bodyDef.angle = Math.PI / 5.0;
            var bazooka:b2Body = shapeBuilder.buildBazooka(ZOOKA_WIDTH, ZOOKA_HEIGHT, bodyDef, 0.0, 0.5, 0.1, 2);
            
            // add a joint for the bazooka and player rect
            var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
            revoluteJointDef.enableMotor = true;
     
            revoluteJointDef.userData = shapeBuilder.buildBall(0.2, bodyDef, 0.0, 0.5, 0.1);
            revoluteJointDef.Initialize(cannonBody, bazooka, new b2Vec2(zookaPos.x, zookaPos.y + ZOOKA_HEIGHT));
            var joint:b2RevoluteJoint = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
            
            return bazooka;
        }
        
        private function createGroundSensor(bodyDef:b2BodyDef):b2FixtureDef {
            
            var ground_sensor:b2FixtureDef = new b2FixtureDef();
            ground_sensor.isSensor = true;
            
            var sensorShape:b2PolygonShape = new b2PolygonShape();
            sensorShape.SetAsOrientedBox(10 / scale, 5 / scale, new b2Vec2(0, 27 / scale), 0);
            ground_sensor.shape = sensorShape;
            
            var body:b2Body = world.CreateBody(bodyDef);
            var box:Rectangle = new Rectangle(1, 1);
            box.name = Cannon.GROUND_SENSOR;
            body.SetUserData(box);
            body.CreateFixture(ground_sensor);
            body.ResetMassData() 
            return ground_sensor;
        }
    }
}