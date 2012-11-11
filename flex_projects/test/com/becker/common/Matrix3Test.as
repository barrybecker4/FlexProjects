package com.becker.common {
    import Box2D.Common.Math.b2Vec3;
    import flash.geom.Matrix;
    
    /**
     * ...
     * @author Barry Becker
     */
    public class Matrix3Test {
        
        private var matrix:Matrix3;
        
           
        public function run():String {
            
            var log:String  = runPositiveTests();
            return log;
        }
        
        public function runPositiveTests():String {
            
            var log:String = "\nnow running Matrix tests...\n";
            
            matrix = new Matrix3(new b2Vec3(1, 2, 3), new b2Vec3(2, 0, 1), new b2Vec3(1, 2, 0));
            
            var vec:b2Vec3 = new b2Vec3(3, 2, 1);

            var result:b2Vec3 = matrix.MultVec(vec);
            if (result.x == 8 && result.y == 8 && result.z == 11) {
                log += "Success for multiplication test\n";
            } else {
                log += "<b>Fail</b> Got " + result.x + ", " + result.y + ", " + result.z;
            }
            
            var expDet:Number = 0.08333333333333333;
            var det:Number = matrix.findDeterminate();
            if (det == expDet) {
                log += "Success for determinate test\n";
            } else {
                log += "<b>Fail</b> Got " + det + " when  " + expDet + " was expected.";
            }
            
                
            return log;
        }
        
        
        
        
    }

}