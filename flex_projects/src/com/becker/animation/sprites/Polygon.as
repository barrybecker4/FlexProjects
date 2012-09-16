package  com.becker.animation.sprites {
    import Box2D.Common.Math.b2Vec2;
    import com.becker.common.Images;
    
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Point;

    
    /**
     * Represents a polygon shape and common operations on it.
     * @author Barry Becker
     */
    public class Polygon extends AbstractShape {
        
        private var poly:Shape;
        private var points:Array;
        private var img:DisplayObject;
        private var scale:Number
        private var min:Point;
        private var max:Point;
        
        public function Polygon(points:Array, scale:Number, color:uint = 0x111111) {
            super(color);
            this.points = points;
            this.scale = scale;
            poly = new Shape(); 
            addChild( poly ); 
            
            initBounds(points);
            init();
        }
    
        /**
         * Note: the points get scaled by this
         */
        private function initBounds(pts:Array):void {
            min = new Point(Number.MAX_VALUE, Number.MAX_VALUE);
            max = new Point(-Number.MAX_VALUE, -Number.MAX_VALUE);
            for each (var pt:Object in pts) {
                
                // @@ side effect : scale the points
                pt.x *= scale;
                pt.y *= scale;
                if (pt.x < min.x) {
                    min.x = pt.x;
                }
                if (pt.y < min.y) {
                    min.y = pt.y;
                }
                if (pt.x > max.x) {
                    max.x = pt.x;
                }
                if (pt.y > max.y) {
                    max.y = pt.y;
                }
            }
        }
        
        protected function init():void {
            
            var img:DisplayObject = new Images.GRUNGE;
            var bmd:BitmapData = new BitmapData(img.width, img.height);
            bmd.draw(img);
            
            var boundingWidth:Number = max.x - min.x;
            var boundingHeight:Number = max.y - min.y;
            poly.graphics.lineStyle(0.5, color);              
            var matrix:Matrix = 
                new Matrix(boundingWidth/img.width, 0, 0, boundingHeight/img.height, min.x, min.y);
             
            poly.graphics.beginBitmapFill(bmd, matrix, true, true);              
            poly.graphics.moveTo(points[0].x, points[0].y);  
           
            for (var i:int = 1; i < points.length; i++) {
                poly.graphics.lineTo(points[i].x, points[i].y);  
            }  

            poly.graphics.endFill();                                          
        } 
     }
}