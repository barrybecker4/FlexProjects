package com.becker.animation.box2d.simulations {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.HolonomicRobotBuilder;
    import com.becker.animation.box2d.builders.items.HolonomicRobot;
    import com.becker.animation.box2d.interactors.KeyboardInteractor;
    import com.becker.animation.box2d.interactors.MouseDragInteractor;
    import com.becker.common.PhysicalParameters;
    
    import com.becker.animation.box2d.builders.AbstractBuilder;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    
    import mx.core.UIComponent;
    
    public class HolonomicRobotSimulation extends AbstractSimulation {
        
        private static const POWER_DELTA:Number = 2.0;
        private var builder:BasicShapeBuilder;
        private var robotBuilder:HolonomicRobotBuilder;
        private var robot:HolonomicRobot;
        
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            world.SetGravity(new b2Vec2(0, 0));
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
            robotBuilder = new HolonomicRobotBuilder(world, canvas, scale);
        }
        
        override public function addStaticElements():void {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_staticBody;
            
            // top wall
            bodyDef.position.Set(32, 1);
            bodyDef.angle = -0.01;
            builder.buildBlock(30, 1, bodyDef, 0, params.friction, params.restitution);
            
            // bottom
            bodyDef.position.Set(31, 42);
            bodyDef.angle = 0.003;
            builder.buildBlock(41, 1, bodyDef, 0, params.friction, params.restitution);
            
            // left
            bodyDef.position.Set(0.5, 26);
            bodyDef.angle = 0.003;
            builder.buildBlock(1, 26, bodyDef, 0, params.friction, params.restitution);
            
            // right
            bodyDef.position.Set(71, 26);
            bodyDef.angle = -0.01;
            builder.buildBlock(1.0, 26, bodyDef, 0, params.friction, params.restitution);
        }
        
        override public function addDynamicElements():void {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            robot = robotBuilder.buildInstance(40, 1, params);
        }
        
        override public function createInteractors():void {
            var kbdInteractor:KeyboardInteractor = new KeyboardInteractor(canvas);
            var dragInteractor:MouseDragInteractor = new MouseDragInteractor(canvas, world, scale);
            kbdInteractor.keyPressHandler = keyPressHandler;
            interactors = [kbdInteractor, dragInteractor];
        }
      
        /**
         * Called every time a new frame is drawn.
         * change the car's acceleration based on specifications.
         * Also scrolls the whole scene so it is centered on the car.
         */
        override public function onFrameUpdate():void {
            super.onFrameUpdate();
            
            if (robot) {
                robot.updateForces();
            }
        }
        
        /** 
         * press handler for the KeyboardInteractor 
         * The ABC motors are controlled with these keys:
         * A (angle = 0)   : 'a' increase power, 'z' decrease power
         * B (angle = 120) : 's' increase power, 'x' decrease power
         * C (angle = 240) : 'd' increase power, 'c' decrease power
         */
        private function keyPressHandler(keyCode:uint):void {
           
            if (keyCode == 65) {          // a - increase on first wheel
                robot.changePowerForWheel(0, POWER_DELTA);
            }
            else if (keyCode == 83) {     // s
                robot.changePowerForWheel(1, POWER_DELTA);
            }
            else if (keyCode == 68) {    // d
                robot.changePowerForWheel(2, POWER_DELTA);
            }
            else if (keyCode == 90) {   // z decrease power on first wheel
                robot.changePowerForWheel(0, -POWER_DELTA);
            }
            else if (keyCode == 88) {  // x - decrease power on second wheel
                robot.changePowerForWheel(1, -POWER_DELTA);
            } 
            else if (keyCode == 67) {  // c - decrease power on third wheel
                robot.changePowerForWheel(2, -POWER_DELTA);
            }
        }
    }
}