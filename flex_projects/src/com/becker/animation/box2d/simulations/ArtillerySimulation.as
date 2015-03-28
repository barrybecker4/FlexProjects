package com.becker.animation.box2d.simulations {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    import com.becker.animation.box2d.builders.PlayerCannonBuilder;
    import com.becker.animation.box2d.builders.items.*;
    import com.becker.animation.box2d.interactors.KeyboardInteractor;
    import com.becker.animation.box2d.interactors.MouseButtonInteractor;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
     
    
    /**
     * Simulates an artillery cannon hopping around and shooting stuff.
     */
    public class ArtillerySimulation extends AbstractSimulation {
        
        private var builder:BasicShapeBuilder;   
        private var cannonBuilder:PlayerCannonBuilder; 
        private var cannon:PlayerCannon;
        
        
        override public function initialize(world:b2World, canvas:UIComponent,
                                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
            cannonBuilder = new PlayerCannonBuilder(world, canvas, scale);  
        }
        
        override public function addStaticElements():void { 
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.position.Set(40, 40);
            bodyDef.angle = -0.0;
            bodyDef.type =  b2Body.b2_staticBody;
            builder.buildBlock(100, 2, bodyDef, 0.5, 1.0, 0.1);
       }
        
        override public function addDynamicElements():void {
             
            cannon = cannonBuilder.buildInstance(30, 35, params);
        }
        
        /**
         * Update cannon and bullet behavior based on their state.
         */
        override public function onFrameUpdate():void {
  
            for (var bb:b2Body = world.GetBodyList(); bb; bb = bb.GetNext()) {
                if (bb.GetUserData() != null) {
                    switch (bb.GetUserData().name) {
                        case PlayerCannon.PLAYER :
                            cannon.updateMovement();
                            cannon.pointTowardMouse(canvas.mouseX, canvas.mouseY, scale);
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
        
        override public function get instructions():String {
            return "Artillary simulation based on <a href=\"http://box2dflash.sourceforge.net/\">Box2DAS3</a> "
            +" and Emanuele Feronato's <a href=\"http://www.emanueleferonato.com/2009/09/04/creation-of-a-flash-artillery-game-using-box2d/\">artillary demo.</a>" 
            + "Use spacebar to shoot and arrow keys to move.";
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
            
            if (keyCode == 38) { // up arrow
                cannon.updateJump();
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