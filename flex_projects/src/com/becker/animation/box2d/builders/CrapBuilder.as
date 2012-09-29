package com.becker.animation.box2d.builders
{
    import Box2D.Collision.b2AABB;
    import Box2D.Collision.Shapes.b2CircleShape;
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Dynamics.b2FixtureDef;
    import com.becker.animation.sprites.AbstractShape;
    import com.becker.animation.sprites.Line;
    import com.becker.common.PhysicalParameters;
    
    import com.becker.animation.sprites.Circle;
    import com.becker.animation.sprites.Polygon;
    import com.becker.animation.sprites.Rectangle;
    
    import flash.geom.Point;
    
    import mx.core.UIComponent;
    
    /**
     * Builds a bunch of random crap composed of blocks and circles
     */
    public class CrapBuilder extends AbstractBuilder {

        private static const DEFAULT_X_POS:int = 120;
        private static const DEFAULT_Y_POS:int = 50;
        
        private static const DEFAULT_X_SPREAD:int = 400;
        private static const DEFAULT_Y_SPREAD:int = 150;
        
        private static const DEFAULT_SIZE:Number = 10.0;
        private static const DENSITY:Number = 1.0;
        private static const FRICTION:Number = 0.7;
        private static const RESTITUTION:Number = 0.1;
        
        
        private var xPos:int = DEFAULT_X_POS;
        private var yPos:int = DEFAULT_Y_POS;
        
        private var xSpread:int = DEFAULT_X_SPREAD;
        private var ySpread:int = DEFAULT_Y_SPREAD;
        
        private var shapeSize:Number = DEFAULT_SIZE;
        private var shapeHalfSize:Number = DEFAULT_SIZE / 2.0;
        
        private var builder:BasicShapeBuilder;
        
        
        /** Constructor */
        public function CrapBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
            builder = new BasicShapeBuilder(world, canvas, scale);
        }
      
        public function setSpawnPosition(xpos:int, ypos:int):void {
            this.xPos = xpos;
            this.yPos = ypos;
        }
        
        public function setSpawnSpread(xspread:int, yspread:int):void {
            this.xSpread = xspread;
            this.ySpread = yspread;
        }
        
        public function setShapeSize(value:Number):void {
            this.shapeSize = value;
            shapeHalfSize = value / 2.0;
        }
    
        /**
         * Spawn in a bunch of crap to fall on the bridge.
         */
        public function addCrap(bodyDef:b2BodyDef, 
            numBlocks:int=0, numBalls:int=0, numPolygons:int=0):void {

            addBlocks(numBlocks, shapeSize, bodyDef);
            addBalls(numBalls, shapeSize, bodyDef);
            addPolygons(numPolygons, bodyDef);
        }       
        
        
        
         /*
        private function addRandomCrap():void {
            var bodyDef:b2BodyDef = new b2BodyDef();
            addSmallBalls(40, bodyDef);                       
            addBallsAndBlocks(6, bodyDef);
        } */
        
        
        /** Some random balls and blocks 
        private function addBallsAndBlocks(n:int, bodyDef:b2BodyDef):void {
            
            for (var i:int = 1; i < n; i++) {
                bodyDef.position.Set(Math.random() * 15 + 10, Math.random() * 5);

                var rX:Number = Math.random() + 0.5;
                var rY:Number = Math.random() + 0.5;
          
                if (Math.random() < 0.5) {
                    builder.buildBlock(rX, rY, bodyDef, params.density, params.friction, params.restitution);
                } 
                else {
                    builder.buildBall(rX, bodyDef, params.density, params.friction, params.restitution);
                }  
            }
        }*/
        
        
        public function addBlocks(num:int, size:Number, bodyDef:b2BodyDef):void  {
            
            var halfSize:Number = size / 2.0;
            for (var i:int = 0; i < num; i++){
                setRandomPlacement(bodyDef);
                builder.buildBlock((Math.random() * halfSize + size) / scale, 
                                   (Math.random() * halfSize + size) / scale, 
                                   bodyDef, DENSITY, FRICTION, RESTITUTION);  
            }
        }
        
        public function addBalls(num:int, size:Number, bodyDef:b2BodyDef):void  {
            
            var halfSize:Number = size / 2.0;
            for (var i:int = 0; i < num; i++) {
                setRandomPlacement(bodyDef);          
                builder.buildBall((Math.random() * halfSize + size) / scale, 
                                  bodyDef, DENSITY, FRICTION, RESTITUTION);  
            }
        }
        
        public function addPolygons(num:int, bodyDef:b2BodyDef):void {
            
            for (var i:int = 0; i < num; i++){
                createRandomPolygon(bodyDef);
            }
        }
        
        private function createRandomPolygon(bodyDef:b2BodyDef):void {
            
            setRandomPlacement(bodyDef);
            var pts:Array;
            
            if (Math.random() > 0.66) {
                pts = createQuadrilateralPoints()
            }
            else if (Math.random() > 0.5) { 
                pts = createPentagonPoints();
            }
            else {
                pts = createTrianglePoints();
            }
    
            builder.buildPolygon(pts, bodyDef, DENSITY, FRICTION, RESTITUTION);
        }
        
        private function createQuadrilateralPoints():Array {
            var pts:Array = new Array();
            pts.push(new Point(( -shapeSize - Math.random() * shapeSize) / scale, 
                               ( shapeSize + Math.random() * shapeSize) / scale));
            pts.push(new Point(( -shapeHalfSize - Math.random() * shapeSize) / scale, 
                               (-shapeSize - Math.random() * shapeSize) / scale));
            pts.push(new Point(( shapeHalfSize + Math.random() * shapeSize) / scale, 
                               (-shapeSize - Math.random() * shapeSize) / scale));
            pts.push(new Point(( shapeSize + Math.random() * shapeSize) / scale, 
                               ( shapeSize + Math.random() * shapeSize) / scale));
            return pts;
        }
        
        private function createPentagonPoints():Array {
            var pt0:Point = new Point(0, (10 +Math.random()*10) / scale);
            var pt2:Point = new Point((-5 - Math.random()*10) / scale, (-10 -Math.random()*10) / scale);
            var pt3:Point = new Point(( 5 + Math.random()*10) / scale, (-10 -Math.random()*10) / scale);
            var s:Number = Math.random()/2 + 0.8;
            var pt1:Point = new Point(s*(pt0.x + pt2.x), s*(pt0.y + pt2.y));
            s = Math.random()/2 + 0.8;
            var pt4:Point = new Point(s*(pt3.x + pt0.x), s*(pt3.y + pt0.y));
            return [pt0, pt1, pt2, pt3, pt4]; 
        }
        
        private function createTrianglePoints():Array {
            var pts:Array = new Array();
            pts.push(new Point(0, (10 +Math.random()*10) / scale));
            pts.push(new Point((-5 - Math.random()*10) / scale, (-10 -Math.random()*10) / scale));
            pts.push(new Point(( 5 + Math.random() * 10) / scale, ( -10 -Math.random() * 10) / scale));
            return pts;
        }
        
        /** Random poistion and angle for body definition */
        private function setRandomPlacement(bodyDef:b2BodyDef):void {
            bodyDef.position.Set((Math.random() * xSpread + xPos) / scale, 
                                 (Math.random() * ySpread + yPos) / scale);
            bodyDef.angle = Math.random() * Math.PI;
        }
    }
}