package com.becker.animation.box2d.simulations {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Common.Math.b2Vec2;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.CrapBuilder;
    import com.becker.animation.sprites.TexturedBox;
    import com.becker.common.PhysicalParameters;
    import com.becker.common.Images;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import flash.display.Sprite;
    import mx.core.UIComponent;
     
    
    /**
     * Lets you blow up boxes.
     * See http://www.emanueleferonato.com/2012/01/17/create-real-explosions-with-box2d-adding-textures/
     */
    public class ExplodingBoxesSimulation extends AbstractSimulation {
        
        private var builder:BasicShapeBuilder;   
          
        private var enterPointsVec:Array = new Array();
        private var numEnterPoints:int = 0;
        
        /** the vector of exploding bodies */
        private var explodingBodies:Vector.<b2Body>;
        /** the number of cuts for every explosion */
        private var explosionCuts:Number=5;
        /** explosion x and y center */
        private var explosionX:Number;
        private var explosionY:Number;
        /** explosion radius, useful to determine the velocity of debris */
        private var explosionRadius:Number = 50;
        
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);   
        }
        
        override public function addStaticElements():void {
            
            addWalls();
        }
           
        override public function addDynamicElements():void {
            // calling the debug draw. This is used to show you the bitmaps are correctly applied.
            debugDraw();

            addCrates();
            
            // see intersection() method.
            enterPointsVec = new Array(numEnterPoints);
            
            // listeners
            canvas.stage.addEventListener(MouseEvent.MOUSE_DOWN, boom);
            canvas.addEventListener(Event.ENTER_FRAME, update);
        }
        
        /** adding the four static, undestroyable walls */
        private function addWalls():void {
            addWall(320,480,640,20);
            addWall(320,0,640,20);
            addWall(0,240,20,480);
            addWall(640, 240, 20, 480);
        }
        
         
        /** simple function to add a static wall */
        private function addWall(pX:Number, pY:Number, width:Number, hieght:Number):void {
            var wallShape:b2PolygonShape = new b2PolygonShape();
            wallShape.SetAsBox(width/scale/2, hieght/scale/2);
            var wallFixture:b2FixtureDef = new b2FixtureDef();
            wallFixture.density=0;
            wallFixture.friction=1;
            wallFixture.restitution=0.5;
            wallFixture.shape=wallShape;
            var wallBodyDef:b2BodyDef = new b2BodyDef();
            wallBodyDef.position.Set(pX/scale,pY/scale);
            var wall:b2Body=world.CreateBody(wallBodyDef);
            wall.CreateFixture(wallFixture);
            numEnterPoints++;
        }
        
        /** add a stack of crates */
        private function addCrates():void {
            
            // this is the BitmapData representation of my 100x100 pixels crate image
            // check the library to see both the raw image and CrateImage Sprite
            var crateBitmap:BitmapData = new BitmapData(100, 100);
            crateBitmap.draw(new Images.CRATE);
            
            // this vector stores the clockwise local coordinates of the 100x100 pixels crate
            var crateCoordVector:Array = 
                [new b2Vec2(-50, -50), new b2Vec2(50, -50), new b2Vec2(50, 50), new b2Vec2(-50, 50)];
            
            // then createBody builds the final body and applies the bitmap.
            // the first two arguments are the X and Y position of the center of the crate, in pixels
            createBody(95, 420, crateCoordVector, crateBitmap);
            createBody(245, 420, crateCoordVector, crateBitmap);
            createBody(395, 420, crateCoordVector, crateBitmap);
            createBody(545, 420, crateCoordVector, crateBitmap);
            createBody(170, 320, crateCoordVector, crateBitmap);
            createBody(320, 320, crateCoordVector, crateBitmap);
            createBody(470, 320, crateCoordVector, crateBitmap);
            createBody(245, 220, crateCoordVector, crateBitmap);
            createBody(395, 220, crateCoordVector, crateBitmap);
            createBody(320, 120, crateCoordVector, crateBitmap);
        }
       
        
        /** function to create and texture a dynamic body */
        private function createBody(xPos:Number, yPos:Number, 
                                    verticesArr:Array, texture:BitmapData):void {

            // I need this temp vector to convert pixels coordinates to Box2D meters coordinates
            var vec:Array = new Array();
            for (var i:Number=0; i < verticesArr.length; i++) {
                vec.push(new b2Vec2(verticesArr[i].x / scale,verticesArr[i].y/scale));
            }
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            var boxDef:b2PolygonShape = new b2PolygonShape();
            boxDef.SetAsArray(vec);
            
            bodyDef.position.Set(xPos/scale, yPos/scale);
            // custom userData used to map the texture
            bodyDef.userData = new TexturedBox(numEnterPoints, vec, texture);
            canvas.addChild(bodyDef.userData);    // is this right????
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density=1;
            fixtureDef.friction=0.2;
            fixtureDef.restitution=0.5;
            fixtureDef.shape=boxDef;
            var tempBox:b2Body=world.CreateBody(bodyDef);
            tempBox.CreateFixture(fixtureDef);
            numEnterPoints++;
        }
        
        /** function to create an explosion */
        private function boom(e:MouseEvent):void {
            var cutAngle:Number;
            explosionX = canvas.mouseX;
            explosionY = canvas.mouseY;
            // I am looking for a body under my mouse
            var clickedBody:b2Body=GetBodyAtXY(new b2Vec2(explosionX/scale,explosionY/scale));
            if (clickedBody!=null) {
                // storing the exploding bodies in a vector. I need to do it since I do not want other bodies
                // to be affected by the raycast and explode
                explodingBodies=new Vector.<b2Body>();
                explodingBodies.push(clickedBody);
                // the explosion begins!
                for (var i:Number=1; i<=explosionCuts; i++) {
                    // choosing a random angle
                    cutAngle=Math.random()*Math.PI*2;
                    // creating the two points to be used for the raycast, according to the random angle and mouse position
                    // also notice how I need to add a little offset (i/10) or Box2D will crash. Probably it's not able to 
                    // determine raycast on objects whose area is very very close to zero (or zero)
                    var p1:b2Vec2=new b2Vec2((explosionX+i/10-2000*Math.cos(cutAngle))/scale,(explosionY-2000*Math.sin(cutAngle))/scale);
                    var p2:b2Vec2=new b2Vec2((explosionX+2000*Math.cos(cutAngle))/scale,(explosionY+2000*Math.sin(cutAngle))/scale);
                    world.RayCast(intersection, p1, p2);
                    world.RayCast(intersection, p2, p1);
                    enterPointsVec=new Array(numEnterPoints);
                }
            }
        }
             
        /**
         * this function returns the body at a X,Y coordinate without using a temp body like the one in
         * the original Box2D distribution. It uses QueryPoint method.
         * @return the body ad X,Y coordinate or null
         */ 
        private function GetBodyAtXY(coordinate:b2Vec2):b2Body {
            var touchedBody:b2Body = null;
            world.QueryPoint(GetBodyCallback,coordinate);
            function GetBodyCallback(fixture:b2Fixture):Boolean {
                var shape:b2Shape = fixture.GetShape();
                var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(),coordinate);
                if (inside) {
                    touchedBody = fixture.GetBody();
                    return false;
                }
                return true;
            }
            return touchedBody;
        }
        
        /** update function to simulate and render the world */
        public function update(e:Event):void {
            world.Step(1/30, 10, 10);
            world.ClearForces();
            var spr:Sprite;
            for (var b:b2Body = world.GetBodyList(); b; b = b.GetNext()) {
                spr = b.GetUserData();
                if (spr) {
                    spr.x=b.GetPosition().x*scale;
                    spr.y=b.GetPosition().y*scale;
                    spr.rotation=b.GetAngle()*180/Math.PI;
                }
            }
            world.DrawDebugData();
        }
        
        /** find the intersection of the fixture with the point and its normal. */
        private function intersection(fixture:b2Fixture, 
            point:b2Vec2, normal:b2Vec2, fraction:Number):Number {
                
            if (explodingBodies.indexOf(fixture.GetBody()) != -1) {
                var spr:Sprite = fixture.GetBody().GetUserData();
                
                // Throughout this whole code I use only one global vector, and that is enterPointsVec. Why do I need it you ask? 
                // Well, the problem is that the world.RayCast() method calls this function only when it sees that a given line gets into the body - it doesnt see when the line gets out of it.
                // I must have 2 intersection points with a body so that it can be sliced, thats why I use world.RayCast() again, but this time from B to A - that way the point, at which BA enters the body is the point at which AB leaves it!
                // For that reason, I use a vector enterPointsVec, where I store the points, at which AB enters the body. And later on, if I see that BA enters a body, which has been entered already by AB, I fire the splitObj() function!
                // I need a unique ID for each body, in order to know where its corresponding enter point is - I store that id in the userData of each body.
                if (spr is TexturedBox) {
                    var userD:TexturedBox = spr as TexturedBox;
                    if (enterPointsVec[userD.index]) {
                        // If this body has already had an intersection point, then it now has two intersection points, thus it must be split in two - thats where the splitObj() method comes in.
                        splitObj(fixture.GetBody(), enterPointsVec[userD.index], point.Copy());
                    }
                    else {
                        enterPointsVec[userD.index]=point;
                    }
                }
            }
            return 1;
        }
        
        /** function to get the area of a shape. I will remove tiny shape to increase performance */
        private function getArea(vs:Array, count:uint):Number {
            var area:Number=0.0;
            var p1X:Number=0.0;
            var p1Y:Number=0.0;
            var inv3:Number=1.0 / 3.0;
            for (var i:int = 0; i < count; ++i) {
                var p2:b2Vec2=vs[i];
                var p3:b2Vec2=i+1<count?vs[int(i+1)]:vs[0];
                var e1X:Number=p2.x-p1X;
                var e1Y:Number=p2.y-p1Y;
                var e2X:Number=p3.x-p1X;
                var e2Y:Number=p3.y-p1Y;
                var D:Number = (e1X * e2Y - e1Y * e2X);
                var triangleArea:Number=0.5*D;
                area+=triangleArea;
            }
            return area;
        }

        /** split the object */
        private function splitObj(sliceBody:b2Body, A:b2Vec2, B:b2Vec2):void {
            var origFixture:b2Fixture=sliceBody.GetFixtureList();
            var poly:b2PolygonShape=origFixture.GetShape() as b2PolygonShape;
            var verticesVec:Object = poly.GetVertices();
            var numVertices:int = poly.GetVertexCount();
            var shape1Vertices:Array = new Array();
            var shape2Vertices:Array = new Array();
            var origUserData:TexturedBox = sliceBody.GetUserData();
            var origUserDataId:int = origUserData.index;
            var d:Number;
            var polyShape:b2PolygonShape=new b2PolygonShape();
            var body:b2Body;
            
            // First, destroy the original body and remove its Sprite representation from the childlist.
            world.DestroyBody(sliceBody);
            canvas.removeChild(origUserData);
            
            // The world.RayCast() method returns points in world coordinates, so use the b2Body.GetLocalPoint() to convert them to local coordinates.
            A=sliceBody.GetLocalPoint(A);
            B = sliceBody.GetLocalPoint(B);
            
            // I use shape1Vertices and shape2Vertices to store the vertices of the two new shapes that are about to be created. 
            // Since both point A and B are vertices of the two new shapes, I add them to both vectors.
            shape1Vertices.push(A, B);
            shape2Vertices.push(A, B);
            
            // iterate over all vertices of the original body.
            // use the function det() ("det" stands for "determinant") 
            // to see on which side of AB each point is standing on. The parameters it needs are the coordinates of 3 points:
            // - if it returns a value >0, then the three points are in clockwise order (the point is under AB)
            // - if it returns a value =0, then the three points lie on the same line (the point is on AB)
            // - if it returns a value <0, then the three points are in counter-clockwise order (the point is above AB). 
            for (var i:Number=0; i<numVertices; i++) {
                d = det(A.x, A.y, B.x, B.y, verticesVec[i].x, verticesVec[i].y);
                if (d > 0) {
                    shape1Vertices.push(verticesVec[i]);
                }
                else {
                    shape2Vertices.push(verticesVec[i]);
                }
            }
            
            // In order to be able to create the two new shapes, I need to have the vertices arranged in clockwise order.
            // call my custom method, arrangeClockwise(), which takes as a parameter a vector, representing the coordinates of the 
            // shape's vertices and returns a new vector, with the same points arranged clockwise.
            shape1Vertices=arrangeClockwise(shape1Vertices);
            shape2Vertices = arrangeClockwise(shape2Vertices);
            
            // setting the properties of the two newly created shapes
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type=b2Body.b2_dynamicBody;
            bodyDef.position=sliceBody.GetPosition();
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density=origFixture.GetDensity();
            fixtureDef.friction=origFixture.GetFriction();
            fixtureDef.restitution = origFixture.GetRestitution();
            
            // creating the first shape, if big enough
            if (getArea(shape1Vertices,shape1Vertices.length)>=0.05) {
                polyShape.SetAsArray(shape1Vertices);
                fixtureDef.shape = polyShape;
                bodyDef.userData = new TexturedBox(origUserDataId, shape1Vertices, origUserData.texture);
                canvas.addChild(bodyDef.userData);
                enterPointsVec[origUserDataId] = null;
                body=world.CreateBody(bodyDef);
                body.SetAngle(sliceBody.GetAngle());
                body.CreateFixture(fixtureDef);
                // setting a velocity for the debris
                body.SetLinearVelocity(setExplosionVelocity(body));
                // the shape will be also part of the explosion and can explode too
                explodingBodies.push(body);
            }
            // creating the second shape, if big enough
            if (getArea(shape2Vertices,shape2Vertices.length)>=0.05) {
                polyShape.SetAsArray(shape2Vertices);
                fixtureDef.shape=polyShape;
                bodyDef.userData = new TexturedBox(numEnterPoints,shape2Vertices,origUserData.texture);
                canvas.addChild(bodyDef.userData);
                enterPointsVec.push(null);
                numEnterPoints++;
                body=world.CreateBody(bodyDef);
                body.SetAngle(sliceBody.GetAngle());
                body.CreateFixture(fixtureDef);
                // setting a velocity for the debris
                body.SetLinearVelocity(setExplosionVelocity(body));
                // the shape will be also part of the explosion and can explode too
                explodingBodies.push(body);
            }
        }
        
        /** 
         * this function will determine the velocity of the debris according
         * to the center of mass of the body and the distance from the explosion point
         */
        private function setExplosionVelocity(b:b2Body):b2Vec2 
        {
            var distX:Number = b.GetWorldCenter().x * scale - explosionX;
            if (distX < 0) {
                if (distX < -explosionRadius) {
                    distX=0;
                }
                else {
                    distX=- explosionRadius-distX;
                }
            }
            else {
                if (distX>explosionRadius) {
                    distX=0;
                }
                else {
                    distX=explosionRadius-distX;
                }
            }
            var distY:Number=b.GetWorldCenter().y*scale-explosionY;
            if (distY<0) {
                if (distY<-explosionRadius) {
                    distY=0;
                }
                else {
                    distY=- explosionRadius-distY;
                }
            }
            else {
                if (distY>explosionRadius) {
                    distY=0;
                }
                else {
                    distY=explosionRadius-distY;
                }
            }
            distX*=0.25;
            distY*=0.25;
            return new b2Vec2(distX,distY);
        }
        
        /**
         * First, arrange all given points in ascending order, according to their x-coordinate.
         * Second, take the leftmost and rightmost points (lets call them C and D), and creates tempVec, 
         * where the points arranged in clockwise order will be stored.
         * Then, it iterates over the vertices vector, and uses the det() method. 
         * It starts putting the points above CD from the beginning of the vector, and the points below CD from the end of the vector. 
         */
        private function arrangeClockwise(vec:Array):Array {
            
            var n:int=vec.length,d:Number,i1:int=1,i2:int=n-1;
            var tempVec:Array=new Array(n),C:b2Vec2,D:b2Vec2;
            vec.sort(comp1);
            tempVec[0]=vec[0];
            C=vec[0];
            D=vec[n-1];
            for (var i:Number=1; i<n-1; i++) {
                d=det(C.x,C.y,D.x,D.y,vec[i].x,vec[i].y);
                if (d<0) {
                    tempVec[i1++]=vec[i];
                }
                else {
                    tempVec[i2--]=vec[i];
                }
            }
            tempVec[i1]=vec[n-1];
            return tempVec;
        }
        
        /**
         * This is a compare function, used in the arrangeClockwise() method 
         * - a fast way to arrange the points in ascending order, according to their x-coordinate.
         */
        private function comp1(a:b2Vec2, b:b2Vec2):Number {
            if (a.x>b.x) {
                return 1;
            }
            else if (a.x<b.x) {
                return -1;
            }
            return 0;
        }
        
        /** for debug frawing */
        private function debugDraw():void {
            var debugDraw:b2DebugDraw = new b2DebugDraw();
            var debugSprite:Sprite = new Sprite();
            canvas.addChild(debugSprite);
            debugDraw.SetSprite(debugSprite);
            debugDraw.SetDrawScale(scale);
            debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
            debugDraw.SetFillAlpha(0.5);
            world.SetDebugDraw(debugDraw);
        }
        
        /**
         * This is a function which finds the determinant of a 3x3 matrix.
         * If you studied matrices, you'd know that it returns a positive number if three given points are in clockwise order, 
         * negative if they are in anti-clockwise order and zero if they lie on the same line.
         * Another useful thing about determinants is that their absolute value is two times the face of the 
         * triangle, formed by the three given points.
         * 
         * @return the determinant
         */
        private function det(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):Number {
            return x1*y2+x2*y3+x3*y1-y1*x2-y2*x3-y3*x1;
        }
    }
}

