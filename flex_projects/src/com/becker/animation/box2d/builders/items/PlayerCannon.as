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
    
    public class PlayerCannon extends Cannon {
        
        public static const PLAYER:String = "Player";
        public static const GROUND_SENSOR:String = "groundsensor";
        private static const JUMP_STRENGTH:Number = 100;
        
        public var touchingGround:Boolean;
     
        private var doJump:Boolean = false;
        private var contactListener:CannonContactListener;
        
        /** speed at which the cannon will move */
        private var xspeed:int = 0;
        
                                  
        public function PlayerCannon(cannonBody:b2Body, bazooka:b2Body, contactListener:CannonContactListener) {
                    
             super(cannonBody, bazooka);
             this.contactListener = contactListener;
        }
        
        override public function update():void {
            super.update();
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
            //cannonBody.SetAngle(0);  // prevent it from falling over
        }
        
        /** 
         * @param speed the amount to set the x speed to
         */
        public function setXSpeed(speed:Number):void {
            xspeed = speed;
        }
        
        public function updateJump():void {
            
            if (touchingGround) { // check if the hero can jump
                doJump = true;
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
        
        /** 
         * Change the direction that the cannon is pointing 
         * @param angleDelta the amount to change in radians. 
         */
        public function rotateCannonAngle(angleDelta:Number):void {
            
            cannonBody.SetAwake(true);  
            var newAngle:Number = bazooka.GetAngle() + angleDelta;
            bazooka.SetAngle(newAngle);
        }
       
    }
}