package com.becker.animation.box2d.explosion {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.sprites.ExplodableShape;
    import com.becker.common.Util;
    import flash.display.Sprite;
    import flash.geom.Point;
    import mx.core.UIComponent;
    
    /**
     * Responsible for exploding a polygonal shape into lots of little shards.
     * See http://www.emanueleferonato.com/2012/01/17/create-real-explosions-with-box2d-adding-textures/
     */
    public class Exploder  {
        
        /** Number of cuts to make when exploding. Determines the number of shards you get. */
        private static const NUM_CUTS:int = 6;
        
        public var enterPointsVec:Array = new Array();  
        public var numEnterPoints:int = 0;
        
        private var world:b2World;
        private var canvas:UIComponent;
        private var scale:Number;
        
        /** the vector of exploding bodies */
        private var explodingBodies:Vector.<b2Body>;
        private var expLoc:b2Vec2;
        

        /** Constructor */
        public function Exploder(world:b2World, canvas:UIComponent, scale:Number) {
            this.world = world;
            this.canvas = canvas;
            this.scale = scale;
            enterPointsVec = new Array(0);
        }
        
        /** function to create an explosion. Create roughly equally sized shards. */
        public function explodeBody(body:b2Body, explosionLocation:b2Vec2):void {
            
            this.expLoc = explosionLocation;
            
            explodingBodies = new Vector.<b2Body>();
            explodingBodies.push(body);
            
            // the explosion begins!
            var segmentAng:Number = 2 * Math.PI / NUM_CUTS;
            for (var i:Number = 1; i <= NUM_CUTS; i++) {
                var cutAngle:Number = i * segmentAng + Math.random() * segmentAng / 5.0;
                doRayCast(cutAngle, explosionLocation);
                enterPointsVec = new Array(numEnterPoints);
            }
        }
        
        /**
         * Cast a random ray through the object that is being exploded.
         * Create the two points to be used for the raycast, according to the random angle and mouse position.
         */
        private function doRayCast(cutAngle:Number, explosionLocation:b2Vec2):void {
            
            var sin:Number = 2000.0 * Math.sin(cutAngle);
            var cos:Number = 2000.0 * Math.cos(cutAngle);
            var p1:b2Vec2 = new b2Vec2((explosionLocation.x - cos)/ scale, (explosionLocation.y - sin)/ scale);
            //  new b2Vec2((explosionX + i/10.0 - cos)/ scale, (explosionY - sin)/ scale);
            var p2:b2Vec2 = new b2Vec2((explosionLocation.x + cos) / scale, (explosionLocation.y + sin) / scale);
            
            // RayCast() calls the intersection function only when it 
            // sees that a given line gets into the body - it doesn't see when the line gets out of it.
            // Must have 2 intersection points with a body so that it can be sliced, thats why RayCast() is called again, 
            // but this time from p2 to p1 - that way the point, at which p2p1 enters the body is the point at which p1p2 leaves it.
            world.RayCast(intersection, p1, p2);
            world.RayCast(intersection, p2, p1);
        }
        
        /** find the intersection of the fixture with the point and its normal. */
        private function intersection(fixture:b2Fixture, point:b2Vec2, 
                                      normal:b2Vec2, fraction:Number):Number {
                
            if (explodingBodies.indexOf(fixture.GetBody()) != -1) {
                var spr:Sprite = fixture.GetBody().GetUserData();
                
                // The global vector, enterPointsVec, where the points are stored, at which AB enters the body. 
                // Later on, if BA enters a body, which has been entered already by AB, splitObject() function is fired.
                // Need a unique ID for each body, in order to know where its corresponding enter point is.
                // That id is stored in the userData of each body.
                if (spr is ExplodableShape) {
                    var explodingShape:ExplodableShape = spr as ExplodableShape;
                    if (enterPointsVec[explodingShape.index]) {
                        // If this body has already had an intersection point, then it now has two intersection points.
                        // Thus it must be split in two.
                        var splitter:Splitter = new Splitter(world, canvas, scale, enterPointsVec);
                        splitter.setVelocityGenerator(new ExplosionVelocityGenerator(expLoc, scale));
                        var fragments:Vector.<b2Body> = 
                            splitter.splitObject(fixture.GetBody(), enterPointsVec[explodingShape.index], point.Copy());
                        explodingBodies = explodingBodies.concat(fragments);
                    }
                    else {
                        enterPointsVec[explodingShape.index] = point;
                    }
                }
            }
            return 1;
        }
    }
}

