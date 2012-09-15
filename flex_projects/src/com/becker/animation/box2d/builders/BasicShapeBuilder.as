package com.becker.animation.box2d.builders
{
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.Shapes.b2ShapeDef;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
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
       
        public function buildLine(start:b2Vec2, stop:b2Vec2, bodyDef:b2BodyDef, 
                                  params:PhysicalParameters,
                                  groupIndex:int = int.MAX_VALUE):b2Body {
   
            var lineDef:b2PolygonDef = new b2PolygonDef();
            lineDef.vertexCount = 2;
                 
            lineDef.vertices[0].Set(start.x, start.y);
            lineDef.vertices[1].Set(stop.x, stop.y);
            var diff:Point = new Point(stop.x - start.x, stop.y - start.y);

            lineDef.density = params.density;
            lineDef.friction = params.friction;
            lineDef.restitution = params.restitution;
            if (groupIndex != int.MAX_VALUE) {
                lineDef.filter.groupIndex = groupIndex;
            }
            bodyDef.userData = new Line(diff.x * scale, diff.y * scale);
            
            return addShape(lineDef, bodyDef); 
        }
       
    
        public function buildBlock(width:Number, height:Number, bodyDef:b2BodyDef, 
                density:Number=1.0, friction:Number = 0.5, restitution:Number = 0.2, 
                groupIndex:int = int.MAX_VALUE):b2Body {
            
            var boxDef:b2PolygonDef = new b2PolygonDef();
            boxDef.SetAsBox(width, height);
            boxDef.density = density;
            boxDef.friction = friction;
            boxDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                boxDef.filter.groupIndex = groupIndex;
            }
            bodyDef.userData = new Rectangle(width * 2 * scale, height * 2 * scale);  
            
            return addShape(boxDef, bodyDef);  
        }
        
        public function buildBall(radius:Number, bodyDef:b2BodyDef, 
                density:Number=1.0, friction:Number = 0.5, restitution:Number = 0.2, 
                groupIndex:int = int.MAX_VALUE):b2Body { 
            
            var circleDef:b2CircleDef = new b2CircleDef();
            circleDef.radius = radius;
            circleDef.density = density;
            circleDef.friction = friction;
            circleDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                circleDef.filter.groupIndex = groupIndex;
            }
            bodyDef.userData = new Circle(radius * scale);
            
            return addShape(circleDef, bodyDef);
        }
        
        public function buildPolygon(pts:Array, bodyDef:b2BodyDef, 
                                     density:Number = 1.0, 
                                     friction:Number = 0.5, 
                                     restitution:Number = 0.2, 
                                     groupIndex:int = int.MAX_VALUE):b2Body {
   
            var polyDef:b2PolygonDef = new b2PolygonDef();
            var numPts:int = pts.length;
            polyDef.vertexCount = numPts;
            var vpoints:Array;
            var i:int;
            if (pts[0] is Point) {
                for (i = 0; i < numPts; i++) {                    
                    var pt:Point = pts[i];
                    polyDef.vertices[i].Set(pt.x, pt.y);
                }
                vpoints = pts;
            }
            else if (pts[0] is b2Vec2) {
                vpoints = new Array();
                for (i = 0; i < numPts; i++) {
                 
                    var v:b2Vec2 = pts[i];
                    polyDef.vertices[i].Set(v.x, v.y);
                    vpoints.push(new Point(v.x, v.y));
                }
            }
            else {
                throw new Error("invalid vertix type:"+ pts[0]);
            }
            polyDef.density = density;
            polyDef.friction = friction;
            polyDef.restitution = restitution;
            if (groupIndex != int.MAX_VALUE) {
                polyDef.filter.groupIndex = groupIndex;
            }
            
            bodyDef.userData = new Polygon(vpoints, scale);
            return addShape(polyDef, bodyDef); 
        }
    }
}