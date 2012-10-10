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
    import mx.core.UIComponent;
    
    /**
     * Splits a polygonal shape into two pieces
     * See http://www.emanueleferonato.com/2012/01/17/create-real-explosions-with-box2d-adding-textures/
     */
    public class Splitter  {
        
        /** Box2d has problems if the slices get too thin */
        private static const TOLERANCE:Number = 0.0000001;
        
        public var enterPointsVec:Array = new Array();  
        public var numEnterPoints:int = 0; 
        
        private var world:b2World;
        private var canvas:UIComponent;
        private var scale:Number;
        
        /** the vector of exploding bodies */
        private var explodingBodies:Vector.<b2Body>;
        
        private var velocityGenerator:IVelocityGenerator;
        

        /** Constructor */
        public function Splitter(world:b2World, canvas:UIComponent, scale:Number, enterPointsVec:Array) {
            this.world = world;
            this.canvas = canvas;
            this.scale = scale;
            this.enterPointsVec = enterPointsVec;
        }
        
        /** Optionally set a velocity generator that will determine the velocities at which the shapes separate */
        public function setVelocityGenerator(vGenerator:IVelocityGenerator):void {
            this.velocityGenerator = vGenerator;
        }

        /** 
         * split the object into two objects 
         * @return array containing the one or two split fragments.
         */
        public function splitObject(sliceBody:b2Body, A:b2Vec2, B:b2Vec2):Vector.<b2Body> {
            
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
            
            var fragments:Vector.<b2Body> = new Vector.<b2Body>();
            
            // creating the first shape, if big enough
            if (Util.findArea(shape1Vertices) >= 0.05) {
                fragments.push(createFragment(shape1Vertices, origUserData.index, fixtureDef, bodyDef, sliceBody));
            }
            
            // creating the second shape, if big enough
            if (Util.findArea(shape2Vertices) >= 0.05) {
                fragments.push(createFragment(shape2Vertices, numEnterPoints, fixtureDef, bodyDef, sliceBody));
            }
            return fragments;
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
            // - if it returns a value >0, 
            //    then the three points are in clockwise order (the point is under AB)
            // - if it returns a value =0, 
            //    then the three points lie on the same line (the point is on AB)
            // - if it returns a value <0, 
            //    then the three points are in counter-clockwise order (the point is above AB). 
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
                             fixtureDef:b2FixtureDef, bodyDef:b2BodyDef, sliceBody:b2Body):b2Body {
              
            //trace("shape verts=" + shapeVertices);
            var origUserData:ExplodableShape = sliceBody.GetUserData();
            var polyShape:b2PolygonShape = new b2PolygonShape();
            
            polyShape.SetAsArray(shapeVertices);
            fixtureDef.shape = polyShape;
            bodyDef.userData = new ExplodableShape(index, shapeVertices, scale, origUserData.texture);
            canvas.addChild(bodyDef.userData);
            
            var body:b2Body = world.CreateBody(bodyDef);
            body.SetAngle(sliceBody.GetAngle());
            body.CreateFixture(fixtureDef);
            // setting a velocity for the debris
            if (velocityGenerator) {
                body.SetLinearVelocity(velocityGenerator.setVelocity(body));
            }
            // this shape will be also part of the explosion and can explode too
            enterPointsVec[index] = null;
            return body;
            //explodingBodies.push(body);
        }
    }
}

