package com.becker.animation.box2d {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Common.Math.b2Math;
    import com.becker.animation.sprites.ExplodableShape;
    import com.becker.common.Util;
    import flash.display.Sprite;
    import mx.core.UIComponent;
    
    /**
     * Responsible for exploding a polygonal shape into lots of little shards.
     * See http://www.emanueleferonato.com/2012/01/17/create-real-explosions-with-box2d-adding-textures/
     */
    public class Exploder  {
        
        /** Number of cuts to make when exploding */
        private static const NUM_CUTS:int = 5;
        /** Box2d has broblems if the slices get too thin */
        private static const TOLERANCE:Number = 0.00000000001;
        
        public var enterPointsVec:Array = new Array();  
        public var numEnterPoints:int = 0; 
        
        private var world:b2World;
        private var canvas:UIComponent;
        private var scale:Number;
        
        /** the vector of exploding bodies */
        private var explodingBodies:Vector.<b2Body>;
        
        // explosion center 
        private var explosionX:Number;  
        private var explosionY:Number;  
        
        /** explosion radius, useful to determine the velocity of debris */
        private var explosionRadius:Number = 50;  
        
        /** Constructor */
        public function Exploder(world:b2World, canvas:UIComponent, scale:Number) {
            this.world = world;
            this.canvas = canvas;
            this.scale = scale;
            enterPointsVec = new Array(0);
        }
        
        /** function to create an explosion */
        public function explodeBody(body:b2Body, explosionX:int, explosionY:int):void {
            
            this.explosionX = explosionX;
            this.explosionY = explosionY;
            
            explodingBodies = new Vector.<b2Body>();
            explodingBodies.push(body);
            
            // the explosion begins!
            for (var i:Number = 1; i <= NUM_CUTS; i++) {
                doRandomRayCast(i);
                enterPointsVec = new Array(numEnterPoints);
            }
        }
        
        /**
         * Cast a random ray through the object that is being exploded.
         * Create the two points to be used for the raycast, according to the random angle and mouse position.
         * Need to add a little offset (i/10) or Box2D will crash. Probably it's not able to 
         * determine raycast on objects whose area is very very close to zero (or zero).
         */
        private function doRandomRayCast(i:int):void {

            var cutAngle:Number = Math.random() * Math.PI * 2;
            
            var sin:Number = 2000.0 * Math.sin(cutAngle);
            var cos:Number = 2000.0 * Math.cos(cutAngle);
            var p1:b2Vec2 = new b2Vec2((explosionX + Math.random()/10.0 - cos)/ scale, (explosionY - sin)/ scale);
            //  new b2Vec2((explosionX + i/10.0 - cos)/ scale, (explosionY - sin)/ scale);
            var p2:b2Vec2 = new b2Vec2((explosionX + cos) / scale, (explosionY + sin) / scale);
            world.RayCast(intersection, p1, p2);
            world.RayCast(intersection, p2, p1);
        }
        
        /** find the intersection of the fixture with the point and its normal. */
        private function intersection(fixture:b2Fixture, 
            point:b2Vec2, normal:b2Vec2, fraction:Number):Number {
                
            if (explodingBodies.indexOf(fixture.GetBody()) != -1) {
                var spr:Sprite = fixture.GetBody().GetUserData();
                
                // Only enterPointsVec is global. 
                // The problem is that the world.RayCast() method calls this function only when it 
                // sees that a given line gets into the body - it doesn't see when the line gets out of it.
                // Must have 2 intersection points with a body so that it can be sliced, thats why world.RayCast() is used again, 
                // but this time from B to A - that way the point, at which BA enters the body is the point at which AB leaves it!
                // For that reason, the vector enterPointsVec, where the points are stored, at which AB enters the body. 
                // Later on, if BA enters a body, which has been entered already by AB, splitObject() function is fired.
                // Need a unique ID for each body, in order to know where its corresponding enter point is.
                // That id is stored in the userData of each body.
                if (spr is ExplodableShape) {
                    var userD:ExplodableShape = spr as ExplodableShape;
                    if (enterPointsVec[userD.index]) {
                        // If this body has already had an intersection point, then it now has two intersection points.
                        // Thus it must be split in two.
                        splitObject(fixture.GetBody(), enterPointsVec[userD.index], point.Copy());
                    }
                    else {
                        enterPointsVec[userD.index] = point;
                    }
                }
            }
            return 1;
        }

        /** split the object into two objects */
        private function splitObject(sliceBody:b2Body, A:b2Vec2, B:b2Vec2):void {
            
            var origFixture:b2Fixture = sliceBody.GetFixtureList();
            var poly:b2PolygonShape = origFixture.GetShape() as b2PolygonShape;
            
            var origUserData:ExplodableShape = sliceBody.GetUserData();
            
            // First, destroy the original body and remove its Sprite representation from the childlist.
            world.DestroyBody(sliceBody);
            canvas.removeChild(origUserData);
           
            var shape1Vertices:Array = new Array();
            var shape2Vertices:Array = new Array();
            // The world.RayCast() method returns points in world coordinates, 
            // so use the b2Body.GetLocalPoint() to convert them to local coordinates.
            A = sliceBody.GetLocalPoint(A);
            B = sliceBody.GetLocalPoint(B);
            
            determineVerticesForNewShapes(shape1Vertices, shape2Vertices, A, B, poly);
            
            // In order to be able to create the two new shapes, need to have the vertices arranged in clockwise order.
            // Call custom method, arrangeClockwise(), which takes as a parameter a vector, 
            // representing the coordinates of the shape's vertices and
            // returns a new vector, with the same points arranged clockwise.
            shape1Vertices = Util.arrangeClockwise(shape1Vertices);
            shape2Vertices = Util.arrangeClockwise(shape2Vertices);
            
            // setting the properties of the two newly created shapes
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type=b2Body.b2_dynamicBody;
            bodyDef.position = sliceBody.GetPosition();
            
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = origFixture.GetDensity();
            fixtureDef.friction = origFixture.GetFriction();
            fixtureDef.restitution = origFixture.GetRestitution();
            
            // creating the first shape, if big enough
            if (getArea(shape1Vertices) >= 0.05) {
                trace("shape1 verts=" + shape1Vertices);
                createFragment(shape1Vertices, origUserData.index, fixtureDef, bodyDef, sliceBody);
            }
            
            // creating the second shape, if big enough
            if (getArea(shape2Vertices) >= 0.05) {
                trace("shape2 verts=" + shape2Vertices);
                createFragment(shape2Vertices, numEnterPoints, fixtureDef, bodyDef, sliceBody);
            }
        }
        
        private function determineVerticesForNewShapes(shape1Vertices:Array, shape2Vertices:Array,
                                                       A:b2Vec2, B:b2Vec2, poly:b2PolygonShape):void {

            var verticesVec:Object = poly.GetVertices();
            var numVertices:int = poly.GetVertexCount();
            
            // Use shape1Vertices and shape2Vertices to store the vertices of the two new shapes that are about to be created. 
            // Since both point A and B are vertices of the two new shapes, add them to both vectors.
            shape1Vertices.push(A, B);
            shape2Vertices.push(A, B);
            
            // iterate over all vertices of the original body.
            // use the function det() ("det" stands for "determinant") 
            // to see on which side of AB each point is standing on. The parameters it needs are the coordinates of 3 points:
            // - if it returns a value >0, then the three points are in clockwise order (the point is under AB)
            // - if it returns a value =0, then the three points lie on the same line (the point is on AB)
            // - if it returns a value <0, then the three points are in counter-clockwise order (the point is above AB). 
            for (var i:Number=0; i < numVertices; i++) {
                var d:Number = Util.determinate(A, B, verticesVec[i]);
                if (d > 0) {
                    addIfUnique(shape1Vertices, verticesVec[i]);
                }
                else {
                    addIfUnique(shape2Vertices, verticesVec[i]);
                }
            } 
        }
        
        /**
         * Only add newVert to vertices if its not already there. This is to prevent degenerate
         * polygons that will break box2d.
         * @param vertices list of current vertices.
         * @param newVert vertex to add to vertices if one like it is not already there.
         */
        private function addIfUnique(vertices:Array, newVert:b2Vec2):void {
            
            for each (var v:b2Vec2 in vertices) {
                //var delta:b2Vec2 = b2Math.SubtractVV(v, newVert);
                //if (delta.LengthSquared() <= TOLERANCE) {
                if ((Math.abs(v.x - newVert.x) + Math.abs(v.y - newVert.y)) < TOLERANCE) {
                    trace("skipping v="+ v + " newVert=" + newVert);
                    return;
                }
            }
            vertices.push(newVert);
        }
        
        private function createFragment(shapeVertices:Array, index:int,
                             fixtureDef:b2FixtureDef, bodyDef:b2BodyDef, sliceBody:b2Body):void {
              
            var origUserData:ExplodableShape = sliceBody.GetUserData();
            var polyShape:b2PolygonShape = new b2PolygonShape();
            
            polyShape.SetAsArray(shapeVertices);
            fixtureDef.shape = polyShape;
            bodyDef.userData = new ExplodableShape(index, shapeVertices, origUserData.texture);
            canvas.addChild(bodyDef.userData);
            
            var body:b2Body = world.CreateBody(bodyDef);
            body.SetAngle(sliceBody.GetAngle());
            body.CreateFixture(fixtureDef);
            // setting a velocity for the debris
            body.SetLinearVelocity(setExplosionVelocity(body));
            // the shape will be also part of the explosion and can explode too
            explodingBodies.push(body);
            enterPointsVec[index] = null;
        }
        
        /** function to get the area of a shape. I will remove tiny shape to increase performance */
        private function getArea(vertices:Array):Number {
            var count:uint = vertices.length;
            var area:Number = 0.0;
            var p1X:Number = 0.0;
            var p1Y:Number = 0.0;
            var inv3:Number = 1.0 / 3.0;
            
            for (var i:int = 0; i < count; ++i) {
                var p2:b2Vec2 = vertices[i];
                var p3:b2Vec2 = (i + 1<count)? vertices[int(i+1)] : vertices[0];
                var e1X:Number = p2.x-p1X;
                var e1Y:Number = p2.y-p1Y;
                var e2X:Number = p3.x-p1X;
                var e2Y:Number = p3.y-p1Y;
                var D:Number = (e1X * e2Y - e1Y * e2X);
                var triangleArea:Number = 0.5 * D;
                area+=triangleArea;
            }
            return area;
        }
        
        /** 
         * Determines the velocity vectorof the debris according
         * to the center of mass of the body and the distance from the explosion point.
         * @param body body to find velocidy of
         * @return velocity vector of the body
         */
        private function setExplosionVelocity(body:b2Body):b2Vec2 
        {
            var distX:Number = body.GetWorldCenter().x * scale - explosionX;
            if (distX < 0) {
                if (distX < -explosionRadius) {
                    distX=0;
                }
                else {
                    distX = -explosionRadius-distX;
                }
            }
            else {
                if (distX>explosionRadius) {
                    distX = 0;
                }
                else {
                    distX = explosionRadius-distX;
                }
            }
            var distY:Number = body.GetWorldCenter().y * scale - explosionY;
            if (distY<0) {
                if (distY < -explosionRadius) {
                    distY = 0;
                }
                else {
                    distY = -explosionRadius - distY;
                }
            }
            else {
                if (distY > explosionRadius) {
                    distY = 0;
                }
                else {
                    distY = explosionRadius - distY;
                }
            }
            distX *= 0.25;
            distY *= 0.25;
            return new b2Vec2(distX, distY);
        }
    }
}

