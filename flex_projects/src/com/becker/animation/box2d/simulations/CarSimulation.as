package com.becker.animation.box2d.simulations {
    
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.items.car.Car;
    import com.becker.animation.box2d.builders.CarBuilder;
    import com.becker.animation.box2d.builders.CrapBuilder;
    import com.becker.animation.box2d.builders.items.car.Car;
    import com.becker.animation.box2d.interactors.KeyboardInteractor;
    import com.becker.animation.box2d.interactors.MouseDragInteractor;
    import com.becker.animation.box2d.interactors.KeyboardInteractor;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
     
    
    /**
     * Simulates a car moving with a bunch of balls and crap.
     */
    public class CarSimulation extends AbstractSimulation {

        private var builder:BasicShapeBuilder;   
        private var carBuilder:CarBuilder; 
        private var crapBuilder:CrapBuilder;
        private var car:Car;
                  
        
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
            builder.buildBlock(85, 2, bodyDef, 0.5, 1.0, 0.1);
            
            bodyDef.position.Set(61, 26);
            builder.buildBlock(1.0, 0.4, bodyDef, 0.5, 1.0, 0.1);
            
            bodyDef.angle = 0.1;
            bodyDef.position.Set(-60, 30);
            builder.buildBlock(40, 2, bodyDef, 0.5, 1.0, 0.1);
        }
        
        override public function addDynamicElements():void {
            
            addRandomCrap(); 
            car = carBuilder.buildInstance(14, 20, params);
        }
        
        /**
         * Called every time a new frame is drawn.
         * change the car's acceleration based on specifications
         */
        override public function onFrameUpdate():void {
            
            car.updateMotor();
            
            var xOffset:Number = -scale * car.carBody.GetWorldCenter().x + canvas.width / 2 - car.carBody.GetLinearVelocity().x * 10;
            var yOffset:Number = -scale * car.carBody.GetWorldCenter().y + canvas.height / 2 - car.carBody.GetLinearVelocity().y * 10;
            canvas.x -= (canvas.x - xOffset) / 3;
            canvas.y -= (canvas.y - yOffset) / 3;
        }
          
        private function addRandomCrap():void {
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            crapBuilder.setSpawnSpread(900, 80);
            crapBuilder.setShapeSize(5.0);
            crapBuilder.addCrap(bodyDef, 15, 15, 16);
            crapBuilder.setSpawnSpread(900, 0);
            crapBuilder.addBalls(10, 4, bodyDef);
        } 
        
        override public function createInteractors():void {
            var dragInteractor:MouseDragInteractor = new MouseDragInteractor(canvas, world, scale);
            var kbdInteractor:KeyboardInteractor = new KeyboardInteractor(canvas);
            kbdInteractor.keyPressHandler = keyHandler;
            interactors = [dragInteractor, kbdInteractor];
        }
        
        /** handler for the KeyboardInteractor */
        private function keyHandler(keyCode:uint):void {
           
            if (keyCode == 66) {   // B: braking
                car.braking = true;
            }
            else if (keyCode == 39) {  // right arrow
                car.increaseAcceleration = true;
            } 
            else if (keyCode == 37) {  // left arrow
                car.decreaseAcceleration = true;
            }
        }
     
    }
}

