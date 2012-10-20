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
        
        public var touchingGround:Boolean;
        
        private static const POWER_FACTOR:Number = 0.5;
        private static const JUMP_STRENGTH:Number = 150.0;
        
        private static const NEG_90:Number = 3.0 * Math.PI / 2.0;
        
        private var _cannonBody:b2Body;        
        
        private var _bazooka:b2Body;
        private var doJump:Boolean = false;
        private var contactListener:CannonContactListener;
        
        /** speed at which to emit projectiles */
        public var xspeed:int = 0;
        
                                  
        public function Cannon(cannonBody:b2Body, bazooka:b2Body, contactListener:CannonContactListener) {
                    
             _cannonBody = cannonBody;
             _bazooka = bazooka; 
             this.contactListener = contactListener;
        }
        
        public function update():void {
            bazooka.GetUserData().update();
            xspeed = 0;
        }
        
        public function updateMovement():void {
            if (xspeed) {
                //cannonBody.SetAwake(true);  
                cannonBody.SetLinearVelocity(new b2Vec2(xspeed, cannonBody.GetLinearVelocity().y));
            }
            if (doJump) {
                trace("Jumping!");
                cannonBody.ApplyImpulse(new b2Vec2(0.0, -JUMP_STRENGTH), cannonBody.GetWorldCenter());
                doJump = false;
                touchingGround = false;
            }
            //cannonBody.SetAngle(0);  // preventit from falling over
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
                trace("up arrow pressed. touchingGround=" + touchingGround);
                if (touchingGround) { // check if the hero can jump
                    doJump = true;
                }
            }
        }
        
        public function pointTowardMouse(mouseX:Number, mouseY:Number, scale:Number):void {

            cannonBody.SetAwake(true);  
            var middle:b2Vec2 = new b2Vec2(
                cannonBody.GetPosition().x * scale, 
                cannonBody.GetPosition().y * scale );
           
            // orient toward mouse
            var dist_x:Number = middle.x - mouseX;
            var dist_y:Number = middle.y - mouseY;
            
            bazooka.SetAngle(Math.PI / 2.0 + Math.atan2( -dist_y, -dist_x));
        }
        
        public function startCharging():void {
            bazooka.GetUserData().startCharging();
        }
      
        
        /** fire the cannon bullet */
        public function fire(world:b2World, shapeBuilder:BasicShapeBuilder):void {
            
            var bazookaAngle:Number = NEG_90 + bazooka.GetAngle();
            
            var x:Number = bazooka.GetWorldCenter().x + (0.6 * bazooka.GetUserData().height / shapeBuilder.scale) * Math.cos(bazookaAngle); 
            var y:Number = bazooka.GetWorldCenter().y + (0.6 * bazooka.GetUserData().height / shapeBuilder.scale) * Math.sin(bazookaAngle); 
            
            var bodyDef:b2BodyDef = new b2BodyDef();

            bodyDef.position.Set(x, y);
            bodyDef.type = b2Body.b2_dynamicBody;
            
            var body:b2Body = shapeBuilder.buildBullet(0.4, bodyDef, 1.0, 0.3, 0.2);
            
            var power:int = bazooka.GetUserData().power;
            x = Math.cos(bazookaAngle) * power * POWER_FACTOR;
            y = Math.sin(bazookaAngle) * power * POWER_FACTOR;
            body.ApplyImpulse(new b2Vec2(x, y), body.GetWorldCenter());
            
            // equal and opposite force to the bazzoka
            bazooka.ApplyImpulse(new b2Vec2(-x, -y), bazooka.GetWorldCenter());
            
            // resetting the power
            bazooka.GetUserData().reset();
        }
      

        public function get cannonBody():b2Body {
            return _cannonBody;
        }   
        
        public function get bazooka():b2Body {
            return _bazooka;
        }   
    }
}