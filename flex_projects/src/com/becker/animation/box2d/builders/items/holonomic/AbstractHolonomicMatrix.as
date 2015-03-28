package com.becker.animation.box2d.builders.items.holonomic {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Common.Math.b2Vec3;
    import Box2D.Dynamics.b2Body;
    import com.becker.common.Matrix3;
    import flash.geom.Matrix;
    
    /**
     * A special sort of 3x3 matix used in holonomic calculations.
     */
    public class AbstractHolonomicMatrix extends Matrix3 {
        
        /** Mass * Radius divided by moment of inertia */
        protected static const C:Number = 5.0;
        
        protected static const W2_ANGLE:Number = 2 * Math.PI / 3;
        protected static const W3_ANGLE:Number = 4 * Math.PI / 3;
        
        public function AbstractHolonomicMatrix(c1:b2Vec3, c2:b2Vec3, c3:b2Vec3) {
            super(c1, c2, c3);
        }
    }
}