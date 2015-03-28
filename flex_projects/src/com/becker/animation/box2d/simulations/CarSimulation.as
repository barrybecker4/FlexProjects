package com.becker.animation.box2d.simulations {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.CarBuilder;
    import com.becker.animation.box2d.builders.CrapBuilder;
    import com.becker.animation.box2d.builders.items.car.Car;
    import com.becker.animation.box2d.interactors.KeyboardInteractor;
    import com.becker.animation.box2d.interactors.MouseDragInteractor;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
     
    
    /**
     * Simulates a car moving with a bunch of balls and crap.
     *  * ideas todo:
     *  - add artillery demo. 
     *  - cleanup simple shape construction (inlude positions and params).
     *  - make scene scale with window resize (sort of done).
     *  - make car game. Mount gun on car. 
     *  - make track to follow
     *  - add boyancy pool
     *  - shoot and explode blox
     */
    public class CarSimulation extends AbstractSimulation {

        /** How fast the scene updates to the correct centered location after the car moves. */
        private static const SCENE_SCROLL_RESTITUTION:Number = 10;
        
        private var builder:BasicShapeBuilder;   
        private var carBuilder:CarBuilder; 
        private var crapBuilder:CrapBuilder;
        private var car:Car;
                  
        override public function get instructions():String {
            return "Car simulation based on <a href=\"http://box2dflash.sourceforge.net/\">Box2DAS3</a>. " 
            + "Use arrow keys to accelerate forward or back and b to brake.";
        }
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
            carBuilder = new CarBuilder(world, canvas, scale);  
            crapBuilder = new CrapBuilder(world, canvas, scale);
        }
        
        override public function addStaticElements():void {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            
            bodyDef.position.Set(30, 30);
            bodyDef.angle = -0.05;
            bodyDef.type =  b2Body.b2_staticBody;
            builder.buildBlock(85, 2, bodyDef, 0.5, 1.5, 0.1);
            
            bodyDef.position.Set(61, 26);
            builder.buildBlock(1.0, 0.4, bodyDef, 0.5, 1.5, 0.1);
            
            bodyDef.angle = 0.1;
            bodyDef.position.Set(-60, 30);
            builder.buildBlock(40, 2, bodyDef, 0.5, 1.5, 0.1);
        }
        
        override public function addDynamicElements():void {
            
            addRandomCrap(); 
            car = carBuilder.buildInstance(14, 20, params);
            
            car.carBody.ApplyTorque(1000);
        }
        
        /**
         * Called every time a new frame is drawn.
         * change the car's acceleration based on specifications.
         * Also scrolls the whole scene so it is centered on the car.
         */
        override public function onFrameUpdate():void {
            super.onFrameUpdate();
            car.updateMotor();
            scrollToCarCenter();
            car.updateShockAbsorbers();
        }
        
        private function scrollToCarCenter():void {
            var center:b2Vec2 = car.carBody.GetWorldCenter();
            var velocity:b2Vec2 = car.carBody.GetLinearVelocity();
            var xOffset:Number = -scale * center.x + canvas.width / 2 - velocity.x;
            var yOffset:Number = -scale * center.y + canvas.height / 2 - velocity.y;
            canvas.x -= (canvas.x - xOffset) / SCENE_SCROLL_RESTITUTION;
            canvas.y -= (canvas.y - yOffset) / SCENE_SCROLL_RESTITUTION;
        }
          
        private function addRandomCrap():void {
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            crapBuilder.setSpawnSpread(900, 80);
            crapBuilder.setShapeSize(4.0);
            crapBuilder.addCrap(bodyDef, 15, 15, 16);
            crapBuilder.setSpawnSpread(900, 0);
            crapBuilder.addBalls(40, 3, bodyDef);
        } 
        
        override public function createInteractors():void {
            trace("adding car interacotrs for world=" + world + " canvas=" + canvas);
            var dragInteractor:MouseDragInteractor = new MouseDragInteractor(canvas, world, scale);
            var kbdInteractor:KeyboardInteractor = new KeyboardInteractor(canvas);
            kbdInteractor.keyPressHandler = keyPressHandler;
            kbdInteractor.keyReleaseHandler = keyReleaseHandler;
            interactors = [dragInteractor, kbdInteractor];
        }
        
        /** handler for the KeyboardInteractor */
        private function keyPressHandler(keyCode:uint):void {
           
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
        
        /** handler for the KeyboardInteractor */
        private function keyReleaseHandler(keyCode:uint):void {
           
            if (keyCode == 66) {   // B: braking
                car.braking = false;
            }
            else if (keyCode == 39) {  // right arrow
                car.increaseAcceleration = false;
            } 
            else if (keyCode == 37) {  // left arrow
                car.decreaseAcceleration = false;
            }
        }
     
    }
}

