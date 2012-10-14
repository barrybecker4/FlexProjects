package com.becker.animation.box2d.builders.items {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FilterData;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.BoxWorld;
    import com.becker.animation.sprites.Bazooka;
    import com.becker.animation.sprites.Bullet;
    import com.becker.common.Util;
    
    public class Cannon {
        
        public static const PLAYER:String = "Player";
        public static const BULLET:String = "bullet";
        
        private var _cannonBody:b2Body;        
        private var _sensor:b2FixtureDef;
        
        public var _bazooka:Bazooka;
        public var bazooka_angle:Number;
        
        /** speed at which to emit projectiles */
        public var xspeed:int = 0;
        
        /** defining the power of the bazooka */
        private var power:int = 1;
        
        /**
         * flag to determine if I am charging the bazooka
         *  0 = not charging
         *  1 = positive charge
         * -1 = negative charge
         */
        public var charging:int = 0;
     
                                  
        public function Cannon(cannonBody:b2Body, bazooka:Bazooka, sensor:b2FixtureDef) {
                    
             _cannonBody = cannonBody;
             _bazooka = bazooka; 
             _sensor = sensor;
        }
        
        public function update():void {
             // If I am charging the bazooka (holding the mouse)
            if (charging != 0) {
                // update the power
                power += charging;
                // if the power ran out of range...
                // (I assume max power is 30 because there are 30 frames in the bazooka animation
                if (power > 30|| power <1) {
                    // invert the power
                    charging *= -1;
                    // update the power again
                    power += charging;
                }
                // show the correct bazooka frame
                ////_bazooka.gotoAndStop(power);
            }
        }
        
        public function setAngle(angle:Number):void {
            bazooka_angle = angle;
            bazooka.rotation = bazooka_angle * Util.RAD_TO_DEG; //57.2957795;
        }
        
        /** fire the cannon bullet */
        public function fire(world:b2World, scale:Number):void {
            // reset charging
            charging = 0;
            var bodyDef:b2BodyDef = new b2BodyDef();
            var x:Number = (bazooka.x + (bazooka.width + 3) * Math.cos(bazooka_angle)) / scale;
            var y:Number = (bazooka.y + (bazooka.width + 3) * Math.sin(bazooka_angle)) / scale;
            bodyDef.position.Set(x, y);
            
            var boxDef:b2FixtureDef = new b2FixtureDef();
            
            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsBox(3 / scale, 3 / scale);
            boxDef.shape = shape;
            
            boxDef.friction = 0.3;
            boxDef.density = 1;
            // the bullet now has its own class
            bodyDef.userData = new Bullet(1.0);
            var body:b2Body = world.CreateBody(bodyDef);
            body.CreateFixture(boxDef);
            body.ResetMassData() //SetMassFromShapes();
            // apply the impulse according to the power
            // that "/4" is just a setting to have decent gameplay
            x = Math.cos(bazooka_angle) * power / 4;
            y = Math.sin(bazooka_angle) * power / 4;
            body.ApplyImpulse(new b2Vec2(x, y), body.GetWorldCenter());
            // resetting the power
            power = 1;
            // updating bazooka clip
            //cannon.bazooka.gotoAndStop(1);
        }

        public function get cannonBody():b2Body {
            return _cannonBody;
        }   
        
        public function get bazooka():Bazooka {
            return _bazooka;
        }   
        
        public function get sensor():b2FixtureDef {
            return _sensor;
        }   
        
    }
}