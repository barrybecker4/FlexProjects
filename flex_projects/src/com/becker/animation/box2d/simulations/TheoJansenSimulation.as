package com.becker.animation.box2d.simulations {
    
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.TheoJansenSpiderBuilder;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
     
    
    /**
     * Simulates a spider moving with a bunch of balls and crap.
     */
    public class TheoJansenSimulation extends AbstractSimulation {
        
        private var builder:BasicShapeBuilder;   
        private var spiderBuilder:TheoJansenSpiderBuilder;  
                  
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
            spiderBuilder = new TheoJansenSpiderBuilder(world, canvas, scale);    
        }
        
        override public function addStaticElements():void {
            
            // Add ground body
            var bodyDef:b2BodyDef = new b2BodyDef();
            
            bodyDef.position.Set(30, 30);
            bodyDef.angle = -0.05;
            builder.buildBlock(35, 2, bodyDef, 0, params.friction, params.restitution);
            
            bodyDef.position.Set(61, 26);
            builder.buildBlock(1.0, 0.4, bodyDef, 0, params.friction, params.restitution);
        }
        
        override public function addDynamicElements():void {
            
            addRandomCrap();            
            spiderBuilder.buildInstance(25, 5, params);
        }
           
        private function addRandomCrap():void {
            var bodyDef:b2BodyDef = new b2BodyDef();
            addSmallBalls(40, bodyDef);                       
            addBallsAndBlocks(6, bodyDef);
        } 
                
        private function addSmallBalls(n:int, bodyDef:b2BodyDef):void {
            for (var j:int = 0; j < n; ++j) {
                bodyDef.position.Set(Math.random() * 62 + 1, Math.random());
                builder.buildBall(0.35, bodyDef, 1.0, params.friction, params.restitution);
            }            
        }
        
        /** Some random balls and blocks */
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
        }
     
    }
}

