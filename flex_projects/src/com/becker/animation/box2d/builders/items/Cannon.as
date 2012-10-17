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
        public static const GROUND_SENSOR:String = "groundsensor";
        
        private static const POWER_FACTOR:Number = 0.5;
        private static const JUMP_STRENGTH:Number = 100.0;
        
        private var _cannonBody:b2Body;        
        private var _sensor:b2FixtureDef;
        
        private var _bazooka:b2Body;
        private var doJump:Boolean = false;
        private var contactListener:CannonContactListener;
        
        
        /** speed at which to emit projectiles */
        public var xspeed:int = 0;
        
     
                                  
        public function Cannon(cannonBody:b2Body, bazooka:b2Body, sensor:b2FixtureDef, contactListener:CannonContactListener) {
                    
             _cannonBody = cannonBody;
             _bazooka = bazooka; 
             _sensor = sensor;
             this.contactListener = contactListener;
        }
        
        public function update():void {
            bazooka.GetUserData().update();
            xspeed = 0;
        }
        
        public function updateMovement():void {
            if (xspeed) {
                cannonBody.SetAwake(true);  
                cannonBody.SetLinearVelocity(new b2Vec2(xspeed, cannonBody.GetLinearVelocity().y));
            }
            if (doJump) {
                cannonBody.ApplyImpulse(new b2Vec2(0.0, -JUMP_STRENGTH), cannonBody.GetWorldCenter());
                doJump = false;
            }
            cannonBody.SetAngle(0);
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
                if (contactListener.canJump()) { // checking if the hero can jump
                    doJump = true;
                }
            }
        }
        
        public function pointTowardMouse(mouseX:Number, mouseY:Number, scale:Number):void {
            var middle:b2Vec2 = bazooka.GetWorldCenter();
            middle.x = cannonBody.GetWorldCenter().x + cannonBody.GetPosition().x * scale;
               //cannonBody.GetUserData().x + cannonBody.GetPosition().x * scale;
            middle.y = cannonBody.GetWorldCenter().y + cannonBody.GetPosition().y * scale;
               //cannonBody.GetUserData().y + cannonBody.GetPosition().y * scale;
            // orient toward mouse
            var dist_x:Number = middle.x - mouseX;
            var dist_y:Number = middle.y - mouseY;
            
            bazooka.SetAngle(Math.PI/2.0 + Math.atan2( -dist_y, -dist_x));
        }
        
        public function startCharging():void {
            bazooka.GetUserData().startCharging();
        }
      
        
        /** fire the cannon bullet */
        public function fire(world:b2World, shapeBuilder:BasicShapeBuilder):void {
            
            var bazookaAngle:Number = bazooka.GetAngle();
            var x:Number = bazooka.GetWorldCenter().x + (bazooka.GetUserData().height/shapeBuilder.scale) * Math.cos(3.0 * Math.PI/2.0  + bazookaAngle); 
            var y:Number = bazooka.GetWorldCenter().y + (bazooka.GetUserData().height / shapeBuilder.scale) * Math.sin(3.0 * Math.PI / 2.0  + bazookaAngle); 
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            //trace("start pos = " + x + ", " + y);
            bodyDef.position.Set(x, y);
            bodyDef.type = b2Body.b2_dynamicBody;
            
            var body:b2Body = shapeBuilder.buildBullet(0.4, bodyDef, 1.0, 0.3, 0.2);
            
            var power:int = bazooka.GetUserData().power;
            x = Math.cos(bazookaAngle + 3.0 * Math.PI/2.0 ) * power * POWER_FACTOR;
            y = Math.sin(bazookaAngle + 3.0 * Math.PI/2.0 ) * power * POWER_FACTOR;
            body.ApplyImpulse(new b2Vec2(x, y), body.GetWorldCenter());
            
            // resetting the power
            bazooka.GetUserData().reset();
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