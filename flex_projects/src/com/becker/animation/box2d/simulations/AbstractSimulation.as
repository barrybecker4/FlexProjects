package com.becker.animation.box2d.simulations {
    
    import Box2D.Dynamics.b2World;
    
    import com.becker.animation.box2d.Simulation;
    import mx.core.UIComponent;
    
    /**
     * Default implementations for simulations.
     * @author Barry Becker
     */
    public class AbstractSimulation implements Simulation {
        
        protected var world:b2World;
        protected var canvas:UIComponent;
        protected var density:Number;
        protected var friction:Number;
        protected var restitution:Number;
        
        public function AbstractSimulation() {
        }
        
        public function initialize(world:b2World, canvas:UIComponent,
                            density:Number, friction:Number, restitution:Number):void {
            this.world = world;    
            this.canvas = canvas;
            this.density = density;
            this.friction= friction;
            this.restitution = restitution;
        }
        
        public function addStaticElements():void {
        }
        
        public function addDynamicElements():void {
        }
        
        public function get scale():Number {
            return 20;
        }
    }
}