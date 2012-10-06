package com.becker.animation.box2d.simulations {
    
    import Box2D.Dynamics.b2World;
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
        protected var params:PhysicalParameters
        
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
        
        public function get scale():Number {
            return 20;
        }
        
        public function cleanup():void {
        }
    }
}