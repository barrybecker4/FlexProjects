package com.becker.animation.box2d.builders
{
	import Box2D.Dynamics.b2Body;
	
	public class RagDoll
	{
		private var _head:b2Body;
		private var _torso1:b2Body;
		private var _torso2:b2Body;
		private var _torso3:b2Body
		private var _upperArmL:b2Body; 
		private var _upperArmR:b2Body;
		private var _lowerArmL:b2Body;
		private var _lowerArmR:b2Body; 
        private var _upperLegL:b2Body; 
        private var _upperLegR:b2Body;
        private var _lowerLegL:b2Body; 
        private var _lowerLegR:b2Body;
                                  
		public function RagDoll(head:b2Body, torso1:b2Body, torso2:b2Body, torso3:b2Body, 
			    upperArmL:b2Body, upperArmR:b2Body, lowerArmL:b2Body, lowerArmR:b2Body, 
                upperLegL:b2Body, upperLegR:b2Body, lowerLegL:b2Body, lowerLegR:b2Body) {
                	
             _head = head;
             _torso1 = torso1;  
             _torso2 = torso2;  
             _torso3 = torso3;  
             _upperArmL = upperArmL;  
             _upperArmR = upperArmR;  
             _lowerArmL = lowerArmL;  
             _lowerArmR = lowerArmR;  
             _upperLegL = upperLegL;  
             _upperLegR = upperLegR;  
             _lowerLegL = lowerLegL;  
             _lowerLegR = lowerLegR;  
		}

        public function get head():b2Body {
        	return _head;
        }        
        public function get torso1():b2Body {
            return _torso1;
        }
        public function get torso2():b2Body {
            return _torso2;
        }
        public function get torso3():b2Body {
            return _torso3;
        }
        public function get upperArmL():b2Body {
            return _upperArmL;
        }
        public function get upperArmR():b2Body {
            return _upperArmR;
        }
        public function get lowerArmL():b2Body {
            return _lowerArmL;
        }
        public function get lowerArmR():b2Body {
            return _lowerArmR;
        }
        public function get upperLegL():b2Body {
            return _upperLegL;
        }
        public function get upperLegR():b2Body {
            return _upperLegR;
        }
        public function get lowerLegL():b2Body {
            return _lowerLegL;
        }
        public function get lowerLegR():b2Body {
            return _lowerLegR;
        }      
        
	}
}