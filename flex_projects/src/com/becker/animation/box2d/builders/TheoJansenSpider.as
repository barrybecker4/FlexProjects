package com.becker.animation.box2d.builders {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    
    public class TheoJansenSpider {
        
        private var _chassis:b2Body;        
        private var _wheel:b2Body;
        private var _wheelAnchor:b2Vec2;
     
                                  
        public function TheoJansenSpider(chassis:b2Body, wheel:b2Body, wheelAnchor:b2Vec2) {
                    
             _chassis = chassis;
             _wheel = wheel; 
             _wheelAnchor = wheelAnchor
        }

        public function get chassis():b2Body {
            return _chassis;
        }   
        
        public function get wheel():b2Body {
            return _wheel;
        }   
        
        public function get wheelAnchor():b2Vec2 {
            return _wheelAnchor;
        } 
        
    }
}