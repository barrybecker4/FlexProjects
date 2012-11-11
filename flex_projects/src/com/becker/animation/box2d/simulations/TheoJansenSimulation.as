package com.becker.animation.box2d.simulations {
    
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.CrapBuilder;
    import com.becker.animation.box2d.builders.TheoJansenSpiderBuilder;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
     
    
    /**
     * Simulates a spider moving with a bunch of balls and crap.
     */
    public class TheoJansenSimulation extends AbstractSimulation {
        
        private var builder:BasicShapeBuilder;   
        private var spiderBuilder:TheoJansenSpiderBuilder; 
        private var crapBuilder:CrapBuilder;
                  
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
            spiderBuilder = new TheoJansenSpiderBuilder(world, canvas, scale);    
            crapBuilder = new CrapBuilder(world, canvas, scale);
        }
        
        /** add ground bodies */
        override public function addStaticElements():void {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_staticBody;
            
            bodyDef.position.Set(30, 30);
            bodyDef.angle = -0.05;
            builder.buildBlock(35, 2, bodyDef, 0, params.friction, params.restitution);
            
            bodyDef.position.Set(61, 26);
            builder.buildBlock(1.0, 0.4, bodyDef, 0, params.friction, params.restitution);
        }
        
        override public function addDynamicElements():void {

            addRandomCrap();            
            spiderBuilder.buildInstance(25, 15, params);
        }
           
        private function addRandomCrap():void {
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            crapBuilder.addCrap(bodyDef, 5, 5, 6);
            crapBuilder.setSpawnSpread(800, 0);
            crapBuilder.addBalls(20, 5, bodyDef);
        } 
    }
}

