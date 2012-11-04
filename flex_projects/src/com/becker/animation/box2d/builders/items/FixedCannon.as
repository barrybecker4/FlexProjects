package com.becker.animation.box2d.builders.items {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.CannonContactListener;
    import com.becker.animation.sprites.Bazooka;
    import com.becker.animation.sprites.Bullet;
    import com.becker.common.Util;
    
    public class FixedCannon extends Cannon {
        
        /** Constructor */                        
        public function FixedCannon(cannonBody:b2Body, bazooka:b2Body) {
                    
            super(cannonBody, bazooka);
        }
        
         
        /** 
         * The direction that the cannon is pointing in radians.
         */
        [Bindable]
        public function get gunAngle():Number {
            return bazooka.GetAngle();
        }
        
        public function set gunAngle(angle:Number):void {
            bazooka.SetAngle(angle);
        }
       
    }
}