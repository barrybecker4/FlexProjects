package com.becker.animation.box2d.simulations {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.ExplodeInteractor;
    import com.becker.animation.sprites.TexturedBox;
    import com.becker.common.Images;
    import com.becker.common.PhysicalParameters;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.controls.Alert;
    
    
    /**
     * Lets you blow up boxes.
     * See http://www.emanueleferonato.com/2012/01/17/create-real-explosions-with-box2d-adding-textures/
     */
    public class ExplodingBoxesSimulation extends AbstractSimulation {
        
        private var builder:BasicShapeBuilder;   
        private var explodeInteractor:ExplodeInteractor;
        private var firstTime:Boolean = true;
      
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);  
            explodeInteractor = new ExplodeInteractor(world, canvas, scale);
            canvas.addEventListener(Event.ENTER_FRAME, update); 
        }
      
        override public function addStaticElements():void {
            addWalls();
        }
           
        override public function addDynamicElements():void {
            // calling the debug draw. This is used to show you the bitmaps are correctly applied.
            debugDraw();

            addCrates();
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
            explodeInteractor.numEnterPoints++;
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
            bodyDef.userData = new TexturedBox(explodeInteractor.numEnterPoints, vec, texture);
            canvas.addChild(bodyDef.userData);    // is this right????
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density=1;
            fixtureDef.friction=0.2;
            fixtureDef.restitution=0.5;
            fixtureDef.shape = boxDef;
            var tempBox:b2Body = world.CreateBody(bodyDef);
            tempBox.CreateFixture(fixtureDef);
            explodeInteractor.numEnterPoints++;
        }
      
        
        /** update function to simulate and render the world */
        public function update(e:Event):void {
            
            if (firstTime && canvas.stage != null) {
                canvas.stage.addEventListener(MouseEvent.MOUSE_DOWN, explodeInteractor.doExplosion);
                firstTime = false;
            }
        
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
    }
}

