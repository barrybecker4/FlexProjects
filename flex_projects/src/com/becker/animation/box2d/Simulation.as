package com.becker.animation.box2d {
    
    import Box2D.Dynamics.b2World;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
    
    /**
     * All simulations must implement this interface.
     * @author Barry Becker
     */
    public interface Simulation {
        
        function initialize(world:b2World, canvas:UIComponent,
                            params:PhysicalParameters):void;
        
        function addStaticElements():void
        
        function addDynamicElements():void
        
        function get scale():Number;
    }
}