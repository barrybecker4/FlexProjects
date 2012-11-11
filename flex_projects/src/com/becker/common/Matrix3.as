package com.becker.common {
    
import Box2D.Common.Math.b2Mat33;
import Box2D.Common.Math.b2Vec3;
    
/** 
 * represents a 3x3 matrix 
 */
public class Matrix3 extends b2Mat33 {
        
    /** Constructor */
    public function Matrix3(c1:b2Vec3 = null, c2:b2Vec3 = null, c3:b2Vec3 = null) {
        super(c1, c2, c3);
    }
    
         
    public function MultVec(vec:b2Vec3):b2Vec3 {
        var result:b2Vec3 = new b2Vec3(0, 0, 0);

        result.x = col1.x * vec.x + col2.x * vec.y + col3.x * vec.z;
        result.y = col1.y * vec.x + col2.y * vec.y + col3.y * vec.z;
        result.z = col1.z * vec.x + col2.z * vec.y + col3.z * vec.z;
        
        return result;
    }
        
    
    public function findDeterminate():Number {
        
        var a11:Number = col1.x;
        var a21:Number = col1.y;
        var a31:Number = col1.z;
        var a12:Number = col2.x;
        var a22:Number = col2.y;
        var a32:Number = col2.z;
        var a13:Number = col3.x;
        var a23:Number = col3.y;
        var a33:Number = col3.z;
        
        //float32 det = b2Dot(col1, b2Cross(col2, col3));
        var det:Number =    a11 * (a22 * a33 - a32 * a23) +
                            a21 * (a32 * a13 - a12 * a33) +
                            a31 * (a12 * a23 - a22 * a13);
        if (det != 0.0) {
            det = 1.0 / det;
        }
      
        return det;
    }
    
    public function toString():String {
        return col1.x + ", " + col2.x + ", " + col3.x + "\n"
             + col1.y + ", " + col2.y + ", " + col3.y + "\n"
             + col1.z + ", " + col2.z + ", " + col3.z + "\n";
    }
}
}