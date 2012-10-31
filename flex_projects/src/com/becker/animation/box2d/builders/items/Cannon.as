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
    
    /** an abstract cannon */
    public class Cannon {
        
        public static const BULLET:String = "Bullet";
        
        protected static const POWER_FACTOR:Number = 0.5;
        protected static const NEG_90:Number = 3.0 * Math.PI / 2.0;
        
        private var _cannonBody:b2Body;        
        private var _bazooka:b2Body;
        
                                  
        public function Cannon(cannonBody:b2Body, bazooka:b2Body) {
                    
             _cannonBody = cannonBody;
             _bazooka = bazooka; 
        }
        
        public function update():void {
            bazooka.GetUserData().update();
        }
        
        public function startCharging():void {
            bazooka.GetUserData().startCharging();
        }
       
        /** 
         * fire the cannon bullet if we have bullets to fire.
         */
        public function fire(world:b2World, shapeBuilder:BasicShapeBuilder):void {
            
            if (!bazooka.GetUserData().hasBullets) return;
            
            var bazookaAngle:Number = NEG_90 + bazooka.GetAngle();
            
            var radius:Number = 0.6 * bazooka.GetUserData().height / shapeBuilder.scale;
            var x:Number = bazooka.GetWorldCenter().x + radius * Math.cos(bazookaAngle); 
            var y:Number = bazooka.GetWorldCenter().y + radius * Math.sin(bazookaAngle); 
            
            var bodyDef:b2BodyDef = new b2BodyDef();

            bodyDef.position.Set(x, y);
            bodyDef.type = b2Body.b2_dynamicBody;
            
            var body:b2Body = shapeBuilder.buildBullet(0.4, bodyDef, 1.0, 0.3, 0.2);
            
            var power:int = bazooka.GetUserData().charge;
            x = Math.cos(bazookaAngle) * power * POWER_FACTOR;
            y = Math.sin(bazookaAngle) * power * POWER_FACTOR;
            body.ApplyImpulse(new b2Vec2(x, y), body.GetWorldCenter());
            
            // equal and opposite force to the bazzoka
            bazooka.ApplyImpulse(new b2Vec2(-x, -y), bazooka.GetWorldCenter());
            
            // resetting the power
            bazooka.GetUserData().discharged();
        }
     
        public function get cannonBody():b2Body {
            return _cannonBody;
        }   
        
        public function get bazooka():b2Body {
            return _bazooka;
        }   
    }
}