package com.becker.animation.box2d.simulations {
    
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.CarBuilder;
    import com.becker.animation.box2d.builders.CrapBuilder;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
     
    
    /**
     * Simulates a car moving with a bunch of balls and crap.
     */
    public class CarSimulation extends AbstractSimulation {
        
        private var builder:BasicShapeBuilder;   
        private var carBuilder:CarBuilder; 
        private var crapBuilder:CrapBuilder;
                  
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
            carBuilder = new CarBuilder(world, canvas, scale);  
            crapBuilder = new CrapBuilder(world, canvas, scale);
        }
        
        override public function addStaticElements():void {
            
            // Add ground body
            var bodyDef:b2BodyDef = new b2BodyDef();
            
            bodyDef.position.Set(30, 30);
            bodyDef.angle = -0.05;
            bodyDef.type =  b2Body.b2_staticBody;
            builder.buildBlock(35, 2, bodyDef, 0.5, 1.0, 0.1);
            
            bodyDef.position.Set(61, 26);
            builder.buildBlock(1.0, 0.4, bodyDef, 0.5, 1.0, 0.1);
        }
        
        override public function addDynamicElements():void {
            
            addRandomCrap(); 
            carBuilder.buildInstance(24, 20, params);
        }
          
        private function addRandomCrap():void {
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            crapBuilder.setSpawnSpread(900, 80);
            crapBuilder.setShapeSize(5.0);
            crapBuilder.addCrap(bodyDef, 5, 5, 6);
            crapBuilder.setSpawnSpread(900, 0);
            crapBuilder.addBalls(10, 4, bodyDef);
        } 
     
    }
}

