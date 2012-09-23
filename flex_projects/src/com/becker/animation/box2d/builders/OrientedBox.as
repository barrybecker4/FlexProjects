package com.becker.animation.box2d.builders {
    import Box2D.Common.Math.b2Vec2;
	/**
     * Specification for an oriented block. Usually part of a compound block shape.
     * @author Barry Becker
     */
    public class OrientedBox {
        
        private var _width:Number;
        private var _height:Number;
        private var _center:b2Vec2;
        private var _rotation:Number;
        
        public function OrientedBox(width:Number, height:Number, center:b2Vec2, rotation:Number) {
            _width = width;
            _height = height;6
            _center = center;
            _rotation = rotation;
        }
        

        public function get width():Number {
            return _width;
        }
        
        public function get height():Number {
            return _height;
        }
        
         public function get center():b2Vec2 {
            return _center;
        }
      
        public function get rotation():Number {
            return _rotation;
        }

    }

}