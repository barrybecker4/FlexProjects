package com.becker.animation.box2d {
    
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    
    /**
     * Generates velocity for split shapes.
     * 
     * @author Barry Becker
     */
    public interface IVelocityGenerator {
        
        /**
         * 
         * @param body the body being split
         * @return the velocity for split shapes
         */
        function setVelocity(body:b2Body):b2Vec2;
    }
    
}