package com.becker.animation.box2d.simulations {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Dynamics.Joints.b2WeldJointDef;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.FixedCannonBuilder;
    import com.becker.animation.box2d.builders.CarBuilder;
    import com.becker.animation.box2d.builders.items.*;
    import com.becker.animation.box2d.builders.items.car.Car;
    import com.becker.animation.box2d.interactors.KeyboardInteractor;
    import com.becker.animation.box2d.interactors.MouseButtonInteractor;
    import com.becker.animation.box2d.interactors.MouseDragInteractor;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
    import com.becker.common.Util;
     
    /**
     * Attaches a gun to a car so nothing can get in your way when you drive around.
     */
    public class ArtilleryOnCarSimulation extends AbstractSimulation {
        
        [Bindable]
        public var motorSpeed:Number = 0;
        
        
        /** Amount to change the angle of the cannon incrementally */
        private static const ANGLE_DELTA:Number = Math.PI / 60;
        
        /** How fast the scene updates to the correct centered location after the car moves. */
        private static const SCENE_SCROLL_RESTITUTION:Number = 10;
        
        private var builder:BasicShapeBuilder;   
        private var cannonBuilder:FixedCannonBuilder; 
        private var carBuilder:CarBuilder; 
        private var _cannon:FixedCannon;
        private var _car:Car;
        
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
            cannonBuilder = new FixedCannonBuilder(world, canvas, scale);  
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
             
            _cannon = cannonBuilder.buildInstance(30, 34, params);
            _car = carBuilder.buildInstance(30, 35, params);
            
            // now glue the cannon to the top of the car.
            var weldJointDef:b2WeldJointDef = new b2WeldJointDef();
            weldJointDef.Initialize(_car.carBody, _cannon.cannonBody, _car.carBody.GetWorldCenter());
            world.CreateJoint(weldJointDef);
        }
        
        /** get the car instance once it has been built */
        public function get car():Car {
            return _car;
        }
        
        /** get the cannon instance once it has been built */
        public function get cannon():FixedCannon {
            return _cannon;
        }
        
        [Bindable]
        public function get gunAngle():Number {
            var ang:Number = 90.0 - _cannon.gunAngle * Util.RAD_TO_DEG
            //trace("get a=" + ang);
            return  ang;
        }
        public function set gunAngle(a:Number):void {
            var ang:Number = (90 - a) * Util.DEG_TO_RAD;;
            //trace("set a=" + ang);
            _cannon.gunAngle = ang;
        }
        
        /**
         * Update cannon and bullet behavior based on their state.
         */
        override public function onFrameUpdate():void {
  
            for (var bb:b2Body = world.GetBodyList(); bb; bb = bb.GetNext()) {
                if (bb.GetUserData() != null) {
                    if (bb.GetUserData().name == Cannon.BULLET && bb.GetUserData().isToBeRemoved()) {
                        canvas.removeChild(bb.GetUserData());
                        bb.SetUserData(null);
                        world.DestroyBody(bb);
                    }
                }
            }
            _cannon.update();
            car.updateMotor();
            scrollToCarCenter();
            car.updateShockAbsorbers();
            motorSpeed = car.motorSpeed;
        }
      
        private function scrollToCarCenter():void {
            var center:b2Vec2 = car.carBody.GetWorldCenter();
            var velocity:b2Vec2 = car.carBody.GetLinearVelocity();
            var xOffset:Number = -scale * center.x + canvas.width / 2 - velocity.x;
            var yOffset:Number = -scale * center.y + canvas.height / 2 - velocity.y;
            canvas.x -= (canvas.x - xOffset) / SCENE_SCROLL_RESTITUTION;
            canvas.y -= (canvas.y - yOffset) / SCENE_SCROLL_RESTITUTION;
        }
        
        override public function createInteractors():void {
            var kbdInteractor:KeyboardInteractor = new KeyboardInteractor(canvas);
            var dragInteractor:MouseDragInteractor = new MouseDragInteractor(canvas, world, scale);
            kbdInteractor.keyPressHandler = keyPressHandler;
            kbdInteractor.keyReleaseHandler = keyReleaseHandler;
            interactors = [kbdInteractor, dragInteractor];
        }
        
        public function fireCannon():void {
            _cannon.fire(world, builder);
        }
        
        /** press handler for the KeyboardInteractor */
        private function keyPressHandler(keyCode:uint):void {
           
            if (keyCode == 65) {          // a
                _cannon.gunAngle -= ANGLE_DELTA;
            }
            else if (keyCode == 83) {     // s
                _cannon.gunAngle += ANGLE_DELTA;
            }
            else if (keyCode == 32) {    // space
                _cannon.startCharging();
            }
            else if (keyCode == 66) {   // B: braking
                car.braking = true;
            }
            else if (keyCode == 39) {  // right arrow
                car.increaseAcceleration = true;
            } 
            else if (keyCode == 37) {  // left arrow
                car.decreaseAcceleration = true;
            }
        }
        
        /** release handler for the KeyboardInteractor */
        private function keyReleaseHandler(keyCode:uint):void {
          
            if (keyCode == 32) {    // space
                fireCannon();
            }
            else if (keyCode == 66) {   // B: braking
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