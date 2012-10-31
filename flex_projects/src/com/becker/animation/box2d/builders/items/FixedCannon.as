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
        
                                  
        public function FixedCannon(cannonBody:b2Body, bazooka:b2Body) {
                    
            super(cannonBody, bazooka);
        }
        
        public function setGunAngle(angle:Number):void {
            bazooka.SetAngle(angle);
        }
        
        /** 
         * Change the direction that the cannon is pointing 
         * @param angleDelta the amount to change in radians. 
         */
        public function rotateCannonAngle(angleDelta:Number):void {
            
            //cannonBody.SetAwake(true);  
            var newAngle:Number = bazooka.GetAngle() + angleDelta;
            bazooka.SetAngle(newAngle);
        }
    }
}