package com.becker.animation.box2d.simulations {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.CannonBuilder;
    import com.becker.animation.box2d.builders.items.Cannon;
    import com.becker.animation.box2d.interactors.KeyboardInteractor;
    import com.becker.animation.box2d.interactors.MouseButtonInteractor;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
     
    
    /**
     * Simulates an artillary cannon hopping around and shooting stuff.
     */
    public class ArtillarySimulation extends AbstractSimulation {
        
        private var builder:BasicShapeBuilder;   
        private var cannonBuilder:CannonBuilder; 
        private var cannon:Cannon;
        private var doJump:Boolean = false;
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
            cannonBuilder = new CannonBuilder(world, canvas, scale);  
        }
        
        override public function addStaticElements():void {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            
            bodyDef.position.Set(40, 40);
            bodyDef.angle = -0.02;
            bodyDef.type =  b2Body.b2_staticBody;
            builder.buildBlock(100, 2, bodyDef, 0.5, 1.0, 0.1);
       }
        
        override public function addDynamicElements():void {
             
            cannon = cannonBuilder.buildInstance(20, 80, params);
        }
        
        /**
         * Update cannon and bullet behavior based on their state.
         */
        override public function onFrameUpdate():void {
  
            cannon.xspeed = 0;
            for (var bb:b2Body = world.GetBodyList(); bb; bb = bb.GetNext()) {
                if (bb.GetUserData() != null) {
                    // I know my body is "something", now I have to perform
                    // different actions according to body's name... "Player" or "bullet"
                    switch (bb.GetUserData().name) {
                        case Cannon.PLAYER :
                            if (cannon.xspeed) {
                                bb.SetAwake(true);  
                                bb.SetLinearVelocity(new b2Vec2(cannon.xspeed, bb.GetLinearVelocity().y));
                            }
                            if (doJump) {
                                bb.ApplyImpulse(new b2Vec2(0.0, -1.0), bb.GetWorldCenter());
                                doJump = false;
                            }
                            
                            //bb.m_sweep.a = 0;
                            bb.SetAngle(0);
                            cannon.bazooka.x = bb.GetUserData().x = bb.GetPosition().x * scale;
                            cannon.bazooka.y = bb.GetUserData().y = bb.GetPosition().y * scale;
                            // orient toward mouse
                            var dist_x:Number = cannon.bazooka.x - canvas.mouseX;
                            var dist_y:Number = cannon.bazooka.y - canvas.mouseY;
                            cannon.setAngle(Math.atan2( -dist_y, -dist_x));
                            break;
                        case Cannon.BULLET :
                            // checking if I have to remove the bullet
                            if (bb.GetUserData().has_to_be_removed()) {
                                // removing the bullet
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
            kbdInteractor.keyPressHandler = keyHandler;
            mouseInteractor.buttonPressHandler = mouseDownHandler;
            mouseInteractor.buttonReleaseHandler = mouseUpHandler;
            interactors = [kbdInteractor, mouseInteractor];
        }
        
        /** handler for the KeyboardInteractor */
        private function keyHandler(keyCode:uint):void {
           
            if (keyCode == 39) { // right arrow
                cannon.xspeed = 3;
            } else if (keyCode == 37) { // left arrow
                cannon.xspeed = -3;
            }
            if (keyCode == 8) { // up arrow
                //if (contactListener.can_jump()) { // checking if the hero can jump
                    doJump = true;
                //}
            }
        }
        
        /** handler for the mouseInteractor. Start with positive charging. */
        private function mouseDownHandler():void {
            cannon.charging = 1;
        }
        
        /** handler for the mouseInteractor. Shoot cannon when released. */
        private function mouseUpHandler():void {
            cannon.fire(world, scale);
        }
    }
}