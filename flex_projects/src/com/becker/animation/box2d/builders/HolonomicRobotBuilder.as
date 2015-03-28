package com.becker.animation.box2d.builders {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Dynamics.b2Fixture;
    import com.becker.animation.box2d.builders.items.holonomic.HolonomicRobot;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.common.PhysicalParameters;
    
    import mx.core.UIComponent;
    import com.becker.common.Util;
    
    public class HolonomicRobotBuilder extends AbstractBuilder {
        
        private static const NUM_WHEELS:int = 3;
        private static const RADIUS:Number = 4.0;
        
        private var shapeBuilder:BasicShapeBuilder;
        private var robot:HolonomicRobot;
    
        
        public function HolonomicRobotBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
            shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
        }
       
        public function buildInstance(startX:Number, startY:Number, 
                                      params:PhysicalParameters):HolonomicRobot  {           
            var bodyDef:b2BodyDef;        
            
            bodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            bodyDef.position.Set(startX, startY);
            
            
            var wheels:Array = [];
            
            var body:b2Body = createBody(bodyDef);
           
            
            robot = new HolonomicRobot(body, NUM_WHEELS);
              
            return robot;      
        }
        
        /** Create a compound body for all the fixed car parts. */
        private function createBody(bodyDef:b2BodyDef):b2Body {
  
            var parts:Array = [];
            var angInc:Number = 2.0 * Math.PI / NUM_WHEELS;
            parts.push(new OrientedBox(2, 2, new b2Vec2(0, 0), 0));
            
            for (var i:int = 0; i < NUM_WHEELS; i++) {
                var angle:Number = i * angInc;
                var xOffset:Number = RADIUS * Math.cos(angle);
                var yOffset:Number = RADIUS * Math.sin(angle);
                //trace("xOffset=" + xOffset + " yOffset=" + yOffset + " angle=" + angle);
                var orientedBlock:OrientedBox = 
                    new OrientedBox(0.2, 1, new b2Vec2(xOffset, yOffset), angle);
                
                parts.push(orientedBlock);
            }
            return shapeBuilder.buildCompoundBlock(parts, bodyDef, 2, 0.5, 0.2, -1); 
        }
    }
}