package  com.becker.animation.sprites {
    
    import Box2D.Common.Math.b2Vec2;
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import mx.core.UIComponent;
    
    public class TexturedBox extends AbstractShape { 
        
        public var index:int;
        public var texture:BitmapData;
        
        public function TexturedBox(index:int, verticesVec:Array, texture:BitmapData) {
            
            super(0xaa77ff);
            this.index = index;
            this.texture = texture;
            var halfWidth:int = 0.2 * texture.width;
            var halfHeight:int = 0.2 * texture.height;
            
            // Use the matrix so the center of the shape drawn matches the center of the BitmapData image.
            // "move" the BitmapData projection left by half its width and up by half its height.
            var m:Matrix = new Matrix();
            m.tx = - halfWidth;
            m.ty = - halfHeight;
            
            // Draw lines from each vertex to the next, in clockwise order 
            // and use the beginBitmapFill() method to add the texture.
            
            this.graphics.lineStyle(1);
            this.graphics.beginBitmapFill(texture, m, true, true);
            this.graphics.moveTo(verticesVec[0].x * halfWidth, verticesVec[0].y * halfHeight);
            
            for (var i:int=1; i<verticesVec.length; i++) {
                this.graphics.lineTo(verticesVec[i].x * halfWidth, verticesVec[i].y * halfHeight);
            }
            
            this.graphics.lineTo(verticesVec[0].x * halfWidth, verticesVec[0].y * halfHeight);
            this.graphics.endFill();
        }
    }
}