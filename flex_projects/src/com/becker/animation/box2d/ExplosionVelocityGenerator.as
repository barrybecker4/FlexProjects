package com.becker.animation.box2d {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import flash.geom.Point;
    
    /**
     * Determines the velocity at which fragments separate.
     * See http://www.emanueleferonato.com/2012/01/17/create-real-explosions-with-box2d-adding-textures/
     */
    public class ExplosionVelocityGenerator implements IVelocityGenerator {
       
        /** The explosion radius. Used to determine the velocity of debris. */
        private var EXPLOSION_RADIUS:Number = 50;  
        
        private var VELOCITY_SCALE:Number = 0.25;
        
        private var explosionLocation:Point;
        private var scale:Number;
        

        /** Constructor */
        public function ExplosionVelocityGenerator(explosionLocation:Point, scale:Number) {
            this.explosionLocation = explosionLocation;
            this.scale = scale;
        }
       
        /** 
         * Determines the velocity vectorof the debris according
         * to the center of mass of the body and the distance from the explosion point.
         * @param body body to find velocidy of
         * @return velocity vector of the body
         */
        public function setVelocity(body:b2Body):b2Vec2 
        {
            var distX:Number = body.GetWorldCenter().x * scale - explosionLocation.x;
            if (distX < 0) {
                if (distX < -EXPLOSION_RADIUS) {
                    distX = 0;
                }
                else {
                    distX = -EXPLOSION_RADIUS-distX;
                }
            }
            else {
                if (distX > EXPLOSION_RADIUS) {
                    distX = 0;
                }
                else {
                    distX = EXPLOSION_RADIUS-distX;
                }
            }
            var distY:Number = body.GetWorldCenter().y * scale - explosionLocation.y;
            if (distY<0) {
                if (distY < -EXPLOSION_RADIUS) {
                    distY = 0;
                }
                else {
                    distY = -EXPLOSION_RADIUS - distY;
                }
            }
            else {
                if (distY > EXPLOSION_RADIUS) {
                    distY = 0;
                }
                else {
                    distY = EXPLOSION_RADIUS - distY;
                }
            }
            distX *= VELOCITY_SCALE;
            distY *= VELOCITY_SCALE;
            return new b2Vec2(distX, distY);
        }
    }
}

