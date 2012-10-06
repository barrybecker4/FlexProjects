package com.becker.animation.box2d {
    
    import Box2D.Dynamics.b2World;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
    
    /**
     * All simulations must implement this interface.
     * 
     * @author Barry Becker
     */
    public interface Simulation {
        
        /** Do whatever is needed to intialize the simulation */
        function initialize(world:b2World, canvas:UIComponent,
                            params:PhysicalParameters):void;
        
        /** The static elements never move during the simulation, but they do handle collistions. */
        function addStaticElements():void
        
        /** The dynamic elements move and can be interacted with */
        function addDynamicElements():void
        
        /** How big things are */
        function get scale():Number;
        
        /** Interactors define how the user will interact with the simulation */
        function createInteractors():void
        
        /** When the simulation is done, it should clean up after itself */
        function cleanup():void;
    }
}