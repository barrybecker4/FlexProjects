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
    import com.becker.animation.sprites.Bazooka;
    import com.becker.animation.sprites.Bullet;
    import com.becker.animation.sprites.ExplodableShape;
    import com.becker.animation.sprites.Line;
    import com.becker.common.PhysicalParameters;
    import flash.display.BitmapData;
    
    import com.becker.animation.sprites.Circle;
    import com.becker.animation.sprites.Polygon;
    import com.becker.animation.sprites.Rectangle;
    import com.becker.common.Util;
    
    import flash.geom.Point;
    
    import mx.core.UIComponent;
    
    public class BasicShapeBuilder extends AbstractBuilder {
        
        /** Constructor */
        public function BasicShapeBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
        }
       
        public function buildBlock(width:Number, height:Number, bodyDef:b2BodyDef, 
                density:Number=1.0, friction:Number = 0.5, restitution:Number = 0.2, 
                groupIndex:int = int.MAX_VALUE):b2Body {
            
            var boxDef:b2FixtureDef = new b2FixtureDef();
            boxDef.density = density;
            boxDef.friction = friction;
            boxDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                boxDef.filter.groupIndex = groupIndex;
            }
            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsBox(width, height);
            boxDef.shape = shape;
            bodyDef.userData = new Rectangle(width * 2 * scale, height * 2 * scale);
            
            return addShape(boxDef, bodyDef); 
        }
        
        public function buildSensor(center:b2Vec2, width:Number, height:Number, 
                                    body:b2Body, sensorName:String = "sensor"):void {
         
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.isSensor = true;

            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsOrientedBox(width, height, center);
            fixtureDef.shape = shape;
            fixtureDef.userData = sensorName;
            body.CreateFixture(fixtureDef);
        }
        
        /** remove this and allow passing in the class for the grahic shape */
        public function buildBazooka(width:Number, height:Number, bodyDef:b2BodyDef, 
                density:Number=1.0, friction:Number = 0.5, restitution:Number = 0.2, 
                groupIndex:int = int.MAX_VALUE):b2Body {
            
            var boxDef:b2FixtureDef = new b2FixtureDef();
            boxDef.density = density;
            boxDef.friction = friction;
            boxDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                boxDef.filter.groupIndex = groupIndex;
            }
            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsBox(width, height);
            boxDef.shape = shape;
            bodyDef.userData = new Bazooka(width * 2 * scale, height * 2 * scale);
            
            return addShape(boxDef, bodyDef); 
        }
        
        public function buildBullet(radius:Number, bodyDef:b2BodyDef, 
                density:Number = 1.0, friction:Number = 0.5, restitution:Number = 0.2, 
                duration:uint = 10000,
                groupIndex:int = int.MAX_VALUE):b2Body { 
            
            var circleDef:b2FixtureDef = new b2FixtureDef();
            circleDef.density = density;
            circleDef.friction = friction;
            circleDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                circleDef.filter.groupIndex = groupIndex;
            }
            circleDef.shape = new b2CircleShape(radius);
            bodyDef.userData = new Bullet(radius * scale, duration);
            
            return addShape(circleDef, bodyDef, false); // true (causes slow)
        }

        /**
         * A group of blocks that are glued togeth into one body
         * @return body with children for all the decorating blocks.
         */
        public function buildCompoundBlock(orientedBlocks:Array, bodyDef:b2BodyDef, 
                density:Number=1.0, friction:Number = 0.5, restitution:Number = 0.2, 
                groupIndex:int = int.MAX_VALUE):b2Body {
                
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = density;
            fixtureDef.friction = friction;
            fixtureDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                fixtureDef.filter.groupIndex = groupIndex;
            }
            
            var masterBlock:OrientedBox = orientedBlocks[0];
            
            var mainShape:b2PolygonShape = new b2PolygonShape();
            mainShape.SetAsOrientedBox(masterBlock.width, masterBlock.height, masterBlock.center, masterBlock.rotation);
            fixtureDef.shape = mainShape;
                
            bodyDef.userData = new Rectangle(masterBlock.width * 2 * scale, masterBlock.height * 2 * scale);
            var body:b2Body = addShape(fixtureDef, bodyDef);
            
            for (var i:int = 1; i < orientedBlocks.length; i++) {
                var orientedBlock:OrientedBox = orientedBlocks[i];
                var blockShape:b2PolygonShape = new b2PolygonShape();
                blockShape.SetAsOrientedBox(orientedBlock.width, orientedBlock.height, orientedBlock.center, orientedBlock.rotation);
                
                fixtureDef.shape = blockShape;
                var rect:Rectangle = new Rectangle(orientedBlock.width * 2 * scale, orientedBlock.height * 2 * scale);
                rect.x = orientedBlock.center.x * scale;
                rect.y = orientedBlock.center.y * scale;
                rect.rotation = Util.RAD_TO_DEG * orientedBlock.rotation;
                bodyDef.userData.addChild(rect);
                
                addShapeWithoutFixture(fixtureDef, bodyDef);
            }
            body.ResetMassData();    
            return body;
        }
   
        
        public function buildBall(radius:Number, bodyDef:b2BodyDef, 
                density:Number=1.0, friction:Number = 0.5, restitution:Number = 0.2, 
                groupIndex:int = int.MAX_VALUE):b2Body { 
            
            var circleDef:b2FixtureDef = new b2FixtureDef();
            circleDef.density = density;
            circleDef.friction = friction;
            circleDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                circleDef.filter.groupIndex = groupIndex;
            }
            circleDef.shape = new b2CircleShape(radius);
            bodyDef.userData = new Circle(radius * scale, null, 0x4455ee);
            
            return addShape(circleDef, bodyDef);
        }

        public function buildPolygon(points:Array, bodyDef:b2BodyDef, 
                                     density:Number = 1.0, 
                                     friction:Number = 0.5, 
                                     restitution:Number = 0.2, 
                                     groupIndex:int = int.MAX_VALUE):b2Body {
                                         
            var vpoints:Array = getPointsFromArray(points);
            
            var polyDef:b2FixtureDef = new b2FixtureDef();
            polyDef.density = density;
            polyDef.friction = friction;
            polyDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                polyDef.filter.groupIndex = groupIndex;
            }
            
            var poly:b2PolygonShape = new b2PolygonShape();
            var verts:Array = []
            
            for (var i:int = 0; i < points.length; i++) {
                verts.push(new b2Vec2(vpoints[i].x, vpoints[i].y));
            }
            poly.SetAsArray(verts, vpoints.length);
            polyDef.shape = poly;
           
            bodyDef.userData = new Polygon(vpoints, scale);
            return addShape(polyDef, bodyDef); 
        }
        
        public function buildLine(start:b2Vec2, stop:b2Vec2, bodyDef:b2BodyDef, 
                                  params:PhysicalParameters,
                                  groupIndex:int = int.MAX_VALUE):b2Body {
   
            var lineDef:b2FixtureDef = new b2FixtureDef();
            lineDef.density = params.density;
            lineDef.friction = params.friction;
            lineDef.restitution = params.restitution;
            if (groupIndex != int.MAX_VALUE) {
                lineDef.filter.groupIndex = groupIndex;
            }
            
            var lineShape:b2PolygonShape = new b2PolygonShape();
            var verts:Array = [new b2Vec2(start.x, start.y), new b2Vec2(stop.x, stop.y)]; 
            lineShape.SetAsArray(verts, 2);
            lineDef.shape = lineShape;
            
            var diff:Point = new Point(stop.x - start.x, stop.y - start.y);
            bodyDef.userData = new Line(diff, scale);
            return addShapeWithoutFixture(lineDef, bodyDef); 
        }
        
        /** function to create and texture a dynamic body */
        public function createExplodableBody(xPos:Number, yPos:Number, 
                                    verticesArr:Array, texture:BitmapData, numEnterPoints:int):b2Body {

            // This temp vector helps convert pixel coordinates to Box2D meters coordinates
            var vec:Array = new Array();
            for (var i:Number=0; i < verticesArr.length; i++) {
                vec.push(new b2Vec2(verticesArr[i].x / scale,verticesArr[i].y / scale));
            }
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            var polyDef:b2PolygonShape = new b2PolygonShape();
            polyDef.SetAsArray(vec);
            
            bodyDef.position.Set(xPos/scale, yPos/scale);
            // custom userData used to map the texture
            bodyDef.userData = new ExplodableShape(numEnterPoints, vec, scale, texture);
            
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = 1;
            fixtureDef.friction = 0.5;
            fixtureDef.restitution = 0.2;
            fixtureDef.shape = polyDef;
            
            return addShape(fixtureDef, bodyDef); 
        }

        
        /** Different depending on whether we are passed b2Vec2 or Points */
        private function getPointsFromArray(points:Array):Array {
            
            var vpoints:Array = [];
            var i:int;
            
            if (points[0] is Point) {
                for (i = 0; i < points.length; i++) {                    
                    vpoints.push(points[i]);
                }
            }
            else if (points[0] is b2Vec2) {
                for (i = 0; i < points.length; i++) {
                    var v:b2Vec2 = points[i];
                    vpoints.push(new Point(v.x, v.y));
                }
            }
            else {
                throw new Error("invalid vertex type:" + points[0]);
            }
            return vpoints;
        }
       
    }
}