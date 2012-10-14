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
    
    public class Cannon {
        
        public static const PLAYER:String = "Player";
        public static const BULLET:String = "Bullet";
        
        private static const POWER_FACTOR:Number = 0.5;
        
        private var _cannonBody:b2Body;        
        private var _sensor:b2FixtureDef;
        
        public var _bazooka:b2Body;
        public var bazooka_angle:Number;
        public var doJump:Boolean = false;
        private var _contactListener:CannonContactListener;
        
        //public var joint:b2RevoluteJoint;
        
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
     
                                  
        public function Cannon(cannonBody:b2Body, bazooka:b2Body, sensor:b2FixtureDef, contactListener:CannonContactListener) {
                    
             _cannonBody = cannonBody;
             _bazooka = bazooka; 
             _sensor = sensor;
             _contactListener = contactListener;
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
            xspeed = 0;
        }
        
        public function updateXSpeed(keyCode:int):void {
            
            if (keyCode == 39) { // right arrow
                xspeed = 3;
            } else if (keyCode == 37) { // left arrow
                xspeed = -3;
            }
        }
        
        public function updateJump(keyCode:int):void {
            if (keyCode == 38) { // up arrow
                if (_contactListener.can_jump()) { // checking if the hero can jump
                    doJump = true;
                }
            }
        }
        
        public function pointTowardMouse(mouseX:Number, mouseY:Number, scale:Number):void {
            var tip:b2Vec2 = bazooka.GetWorldCenter();
            tip.x = cannonBody.GetWorldCenter().x + cannonBody.GetPosition().x * scale;
               //cannonBody.GetUserData().x + cannonBody.GetPosition().x * scale;
            tip.y = cannonBody.GetWorldCenter().y + cannonBody.GetPosition().y * scale;
               //cannonBody.GetUserData().y + cannonBody.GetPosition().y * scale;
            // orient toward mouse
            var dist_x:Number = tip.x - mouseX;
            var dist_y:Number = tip.y - mouseY;
            setAngle(Math.PI/2.0 + Math.atan2( -dist_y, -dist_x));
        }
        
        public function setAngle(angle:Number):void {
            bazooka_angle = angle;
            bazooka.SetAngle(bazooka_angle); // * Util.RAD_TO_DEG;
        }
        
        /** fire the cannon bullet */
        public function fire(world:b2World, shapeBuilder:BasicShapeBuilder):void {
            
            charging = 0;
            
            var x:Number = bazooka.GetWorldCenter().x + (bazooka.GetUserData().height/shapeBuilder.scale) * Math.cos(3.0 * Math.PI/2.0  + bazooka_angle); // shapeBuilder.scale;
            var y:Number = bazooka.GetWorldCenter().y + (bazooka.GetUserData().height/shapeBuilder.scale) * Math.sin(3.0 * Math.PI/2.0  + bazooka_angle); // shapeBuilder.scale;
            var bodyDef:b2BodyDef = new b2BodyDef();
            //trace("start pos = " + x + ", " + y);
            bodyDef.position.Set(x, y);
            bodyDef.type = b2Body.b2_dynamicBody;
            
            var body:b2Body = shapeBuilder.buildBullet(0.4, bodyDef, 1.0, 0.3, 0.2);
            
            x = Math.cos(bazooka_angle + 3.0*Math.PI/2.0 ) * power * POWER_FACTOR;
            y = Math.sin(bazooka_angle + 3.0*Math.PI/2.0 ) * power * POWER_FACTOR;
            body.ApplyImpulse(new b2Vec2(x, y), body.GetWorldCenter());
            // resetting the power
            power = 1;
            // updating bazooka clip
            //cannon.bazooka.gotoAndStop(1);
        }

        public function get cannonBody():b2Body {
            return _cannonBody;
        }   
        
        public function get bazooka():b2Body {
            return _bazooka;
        }   
        
        public function get sensor():b2FixtureDef {
            return _sensor;
        }   
        
    }
}