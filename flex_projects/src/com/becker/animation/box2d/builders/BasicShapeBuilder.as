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
    
    public class BasicShapeBuilder extends AbstractBuilder {

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
            bodyDef.userData = [new Rectangle(width * 2 * scale, height * 2 * scale)];  
            
            return addShapes(boxDef, bodyDef);  
        }
        
        public function buildCompoundBlock(orientedBlocks:Array, bodyDef:b2BodyDef, 
                density:Number=1.0, friction:Number = 0.5, restitution:Number = 0.2, 
                groupIndex:int = int.MAX_VALUE):b2Body {
                
            var boxDef:b2FixtureDef = new b2FixtureDef();
            boxDef.density = density;
            boxDef.friction = friction;
            boxDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                boxDef.filter.groupIndex = groupIndex;
            }
            
            bodyDef.userData = [];
            var body:b2Body = world.CreateBody(bodyDef);
            
            for each (var block:OrientedBox in orientedBlocks) {
                var blockShape:b2PolygonShape = new b2PolygonShape();
                blockShape.SetAsOrientedBox(block.width, block.height, block.center, block.rotation);
                var shape:Rectangle = new Rectangle(block.width * 2 * scale, block.height * 2 * scale);
                canvas.addChild(shape);
                bodyDef.userData.push(shape); 
                boxDef.shape = blockShape;
                body.CreateFixture(boxDef);
            }

            body.ResetMassData();    
            
            return body;  
        }
        
        public function buildBall(radius:Number, bodyDef:b2BodyDef, 
                density:Number=1.0, friction:Number = 0.5, restitution:Number = 0.2, 
                groupIndex:int = int.MAX_VALUE):b2Body { 
            
            var circleDef:b2FixtureDef = new b2FixtureDef();
            //circleDef.radius = radius;
            circleDef.density = density;
            circleDef.friction = friction;
            circleDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                circleDef.filter.groupIndex = groupIndex;
            }
            circleDef.shape = new b2CircleShape(radius);
            bodyDef.userData = [new Circle(radius * scale)];
            
            return addShapes(circleDef, bodyDef);
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
           
            bodyDef.userData = [new Polygon(vpoints, scale)];
            return addShapes(polyDef, bodyDef); 
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
            var diff:Point = new Point(stop.x - start.x, stop.y - start.y);
            lineDef.shape = lineShape;
            
            bodyDef.userData = [new Line(diff, scale)];
            bodyDef.type = b2Body.b2_dynamicBody;
            
            return addShapes(lineDef, bodyDef); 
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