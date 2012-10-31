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
    import com.becker.animation.box2d.builders.items.FixedCannon;
    import com.becker.animation.sprites.Bazooka;
    import com.becker.animation.sprites.Rectangle;
    import com.becker.common.PhysicalParameters;
    import flash.events.Event;
    import mx.core.UIComponent;
    
    /**
     * Build a fixed block with attached rotatable cannon.
     */
    public class FixedCannonBuilder extends AbstractBuilder {
        
        private static const SIZE:Number = 2.5;
        private static const BLOCK_WIDTH:Number = 1.4;
        private static const BLOCK_HEIGHT:Number = 1.0;
        
        private static const ZOOKA_WIDTH:Number = 0.3;
        private static const ZOOKA_HEIGHT:Number = 1.2;

        private var shapeBuilder:BasicShapeBuilder;
        private var params:PhysicalParameters;   
        private var cannon:FixedCannon;
      
    
        /** Constructor */
        public function FixedCannonBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
            shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        public function buildInstance(startX:Number, startY:Number, 
                                      params:PhysicalParameters):FixedCannon {
 
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            bodyDef.position.Set(startX, startY);
            
            var cannonBody:b2Body = 
                shapeBuilder.buildBlock(BLOCK_WIDTH, BLOCK_HEIGHT, bodyDef, params.density, params.friction, params.restitution, 1);
            
            var zookaPos:b2Vec2 = new b2Vec2(startX, startY - BLOCK_HEIGHT - ZOOKA_HEIGHT/2.0);
            var bazooka:b2Body = createAttachedBazooka(zookaPos, bodyDef, cannonBody);
            
            cannon = new FixedCannon(cannonBody, bazooka);
            bazooka.SetAngle(Math.PI / 3.0);
            
            return cannon;
        }
        
        private function createAttachedBazooka(zookaPos:b2Vec2, bodyDef:b2BodyDef, cannonBody:b2Body):b2Body {
            
            bodyDef.position = zookaPos;  
            var bazooka:b2Body = shapeBuilder.buildBazooka(ZOOKA_WIDTH, ZOOKA_HEIGHT, bodyDef, 0.0, 0.5, 0.1, 2);
            
            // add a joint for the bazooka and player rect
            var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
            revoluteJointDef.enableMotor = true;
     
            //revoluteJointDef.userData = shapeBuilder.buildBall(0.2, bodyDef, 0.0, 0.5, 0.1);
            revoluteJointDef.Initialize(cannonBody, bazooka, new b2Vec2(zookaPos.x, zookaPos.y + ZOOKA_HEIGHT));
            var joint:b2RevoluteJoint = world.CreateJoint(revoluteJointDef) as b2RevoluteJoint;
            
            return bazooka;
        }
    }
}