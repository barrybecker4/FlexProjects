package com.becker.animation.box2d.simulations {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.CrapBuilder;
    import com.becker.common.PhysicalParameters;
    
    import com.becker.animation.box2d.builders.AbstractBuilder;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    
    import flash.geom.Point;
    
    import mx.core.UIComponent;
    
    public class BridgeSimulation extends AbstractSimulation {
        private static const NUM_SHAPES:Number = 50;
        private static const NUM_PLANKS:int = 10;
        
        /** the length of one of the bridge planks */
        private static const PLANK_LENGTH:Number = 44;
        private static const HALF_PLANK_LENGTH:Number = PLANK_LENGTH / 2.0;
        
        private static const BRIDGE_HEIGHT:Number = 250;
        private static const BRIDGE_STARTX:Number = 100;
        
        private var shapeBuilder:BasicShapeBuilder;
        private var crapBuilder:CrapBuilder;
        
        private var ground:b2Body;
        private var anchor:b2Vec2;   
        
        
        override public function initialize(world:b2World, canvas:UIComponent,
                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
            crapBuilder = new CrapBuilder(world, canvas, scale);
        }
        
        override public function addStaticElements():void {
            
            ground = world.GetGroundBody();
            anchor = new b2Vec2();   
        }
        
    
        override public function addDynamicElements():void {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            addBridge(bodyDef);
            crapBuilder.addCrap(bodyDef, 6, 5, 15);
        }
        
        /**
         * Bridge
         */
        private function addBridge(bodyDef:b2BodyDef):void {
            
            var body:b2Body;
            //var body:b2Body = builder.buildBlock(24/scale, 5/scale, bodyDef, 20.0, 0.2, 0.1);  
            
            var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
            jd.lowerAngle = AbstractBuilder.degreesToRadians(-15); 
            jd.upperAngle = AbstractBuilder.degreesToRadians(15);
            jd.enableLimit = true;
            
            var prevBody:b2Body = ground;
            
            for (var i:int = 0; i < NUM_PLANKS; ++i) {
                bodyDef.position.Set((BRIDGE_STARTX + HALF_PLANK_LENGTH + PLANK_LENGTH * i) / scale, BRIDGE_HEIGHT/ scale);
                body = shapeBuilder.buildBlock(24/scale, 5/scale, bodyDef, 20.0, 0.2, 0.1);  
                
                anchor.Set((BRIDGE_STARTX + PLANK_LENGTH * i) / scale, BRIDGE_HEIGHT / scale);
                jd.Initialize(prevBody, body, anchor);
                world.CreateJoint(jd);
                
                prevBody = body;
            }
            
            anchor.Set((BRIDGE_STARTX + PLANK_LENGTH * NUM_PLANKS) / scale, BRIDGE_HEIGHT / scale);
            jd.Initialize(prevBody, ground, anchor);
            world.CreateJoint(jd);
        }
    }
}