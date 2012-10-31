package com.becker.animation.box2d.simulations {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Dynamics.Joints.b2WeldJointDef;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.CannonBuilder;
    import com.becker.animation.box2d.builders.CarBuilder;
    import com.becker.animation.box2d.builders.items.Cannon;
    import com.becker.animation.box2d.builders.items.car.Car;
    import com.becker.animation.box2d.interactors.KeyboardInteractor;
    import com.becker.animation.box2d.interactors.MouseButtonInteractor;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
     
    
    /**
     * Attaches a gun to a car so nothing can get in your way when you drive around.
     */
    public class ArtilleryOnCarSimulation extends AbstractSimulation {
        
        private static const ANGLE_DELTA:Number = Math.PI / 60;
        
        private var builder:BasicShapeBuilder;   
        private var cannonBuilder:CannonBuilder; 
        private var carBuilder:CarBuilder; 
        private var cannon:Cannon;
        private var _car:Car;
        
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
            cannonBuilder = new CannonBuilder(world, canvas, scale);  
            carBuilder = new CarBuilder(world, canvas, scale);  
        }
        
        override public function addStaticElements():void { 
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.position.Set(40, 40);
            bodyDef.angle = -0.0;
            bodyDef.type =  b2Body.b2_staticBody;
            builder.buildBlock(100, 2, bodyDef, 0.5, 1.0, 0.1);
       }
        
        override public function addDynamicElements():void {
             
            cannon = cannonBuilder.buildInstance(30, 34, params);
            _car = carBuilder.buildInstance(30, 35, params);
            
            // now glue the cannon to the top of the car.
            var weldJointDef:b2WeldJointDef = new b2WeldJointDef();
            weldJointDef.Initialize(_car.carBody, cannon.cannonBody, _car.carBody.GetWorldCenter());
            world.CreateJoint(weldJointDef);
        }
        
          
        /** get the car instance once it has been built */
        public function get car():Car {
            return _car;
        }
        
        /**
         * Update cannon and bullet behavior based on their state.
         */
        override public function onFrameUpdate():void {
  
            for (var bb:b2Body = world.GetBodyList(); bb; bb = bb.GetNext()) {
                if (bb.GetUserData() != null) {
                    switch (bb.GetUserData().name) {
                        case Cannon.PLAYER :
                            cannon.updateMovement();
                            //cannon.pointTowardMouse(canvas.mouseX, canvas.mouseY, scale);
                            break;
                        case Cannon.BULLET :
                            if (bb.GetUserData().isToBeRemoved()) {
                                canvas.removeChild(bb.GetUserData());
                                bb.SetUserData(null);
                                world.DestroyBody(bb);
                            }
                            break;
                    }
                }
            }
            cannon.update();
        }
        
        override public function createInteractors():void {
            var kbdInteractor:KeyboardInteractor = new KeyboardInteractor(canvas);
            var mouseInteractor:MouseButtonInteractor = new MouseButtonInteractor(canvas);
            //var dragInteractor:MouseDragInteractor = new MouseDragInteractor(canvas, world, scale);
            kbdInteractor.keyPressHandler = keyHandler;
            mouseInteractor.buttonPressHandler = mouseDownHandler;
            mouseInteractor.buttonReleaseHandler = mouseUpHandler;
            interactors = [kbdInteractor, mouseInteractor];
        }
        
        /** handler for the KeyboardInteractor */
        private function keyHandler(keyCode:uint):void {
           
            if (keyCode == 39) { // right arrow
                cannon.setXSpeed(3); 
            } else if (keyCode == 37) { // left arrow
                cannon.setXSpeed(-3); 
            }
            else if (keyCode == 38) { // up arrow
                cannon.updateJump();
            }
            else if (keyCode == 65) {  // a
                cannon.rotateCannonAngle(-ANGLE_DELTA);
            }
            else if (keyCode == 83) { // s
                cannon.rotateCannonAngle(ANGLE_DELTA);
            }
        }
        
        /** handler for the mouseInteractor. Start with positive charging. */
        private function mouseDownHandler():void {
            cannon.startCharging();
        }
        
        /** handler for the mouseInteractor. Shoot cannon when released. */
        private function mouseUpHandler():void {
            cannon.fire(world, builder);
        }
    }
}