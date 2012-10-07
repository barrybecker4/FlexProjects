package com.becker.animation.box2d.simulations {
    
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.interactors.Interactor;
    import com.becker.animation.box2d.interactors.MouseDragInteractor;
    import com.becker.common.PhysicalParameters;
    
    
    import com.becker.animation.box2d.Simulation;
    import mx.core.UIComponent;
    
    /**
     * Default implementations for simulations.
     * @author Barry Becker
     */
    public class AbstractSimulation implements Simulation {
        
        protected var world:b2World;
        protected var canvas:UIComponent;
        protected var params:PhysicalParameters;
        protected var interactors:Array;
        
        /** an array of interactors to us in the simulation */
        protected var _interactors:Array;
        
        public function AbstractSimulation() {}
        
        public function initialize(world:b2World, canvas:UIComponent,
                                   params:PhysicalParameters):void {
            this.world = world;    
            this.canvas = canvas;
            this.params = params;
        }
        
        public function addStaticElements():void {
        }
        
        public function addDynamicElements():void {
        }
        
        /**
         * Called every time a new frame is drawn.
         * The default is to do nothing.
         */
        public function onFrameUpdate():void {
        }
        
        public function createInteractors():void {
            interactors = [new MouseDragInteractor(canvas, world, scale)];
        }
        
        /** Cleanup when the simulation is destroyed */
        public function cleanup():void {
            for each (var interactor:Interactor in interactors) {
                interactor.removeHandlers();
            }
            canvas.x = 0;
            canvas.y = 0;
        }
        
        public function get scale():Number {
            return 20;
        }
    }
}