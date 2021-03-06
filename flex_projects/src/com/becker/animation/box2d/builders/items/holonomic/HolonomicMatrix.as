package com.becker.animation.box2d.builders.items.holonomic {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Common.Math.b2Vec3;
    import Box2D.Dynamics.b2Body;
    import com.becker.common.Matrix3;
    import flash.geom.Matrix;
    
    /**
     * A special sort of 3x3 matix used in holonomic calculations.
     */
    public class HolonomicMatrix extends AbstractHolonomicMatrix {

        /**
         * Constructor
         * @param	angle angle of rotation of the robot in radians
         */
        public function HolonomicMatrix(angle:Number) {
                    
            super(new b2Vec3( -Math.sin(angle), Math.cos(angle), C),
                  new b2Vec3( -Math.sin(W2_ANGLE + angle), Math.cos(W2_ANGLE + angle), C),
                  new b2Vec3( -Math.sin(W3_ANGLE + angle), Math.cos(W3_ANGLE + angle), C));
        }
    }
}