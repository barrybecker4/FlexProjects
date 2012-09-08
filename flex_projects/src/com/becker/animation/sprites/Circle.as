package  com.becker.animation.sprites {
    
    import com.becker.common.Images;
    
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.geom.Matrix;
    
    /**
     * Represents a 2D ball and common operations on it.
     * @author Barry Becker
     */
    public class Circle extends AbstractShape {
        
        private var radius:Number;
        private var circle:Shape;
        
               
        public function Circle(radius:Number, color:uint = 0x9988cc) {
            super(color);
            this.radius = radius;
            circle = new Shape(); 
            addChild( circle ); 
            
            init();
        }
    
        
        protected function init():void {
            
            var img:DisplayObject = new Images.GRUNGE;
            var bmd:BitmapData = new BitmapData(img.width, img.height);
            bmd.draw(img);
            
            circle.graphics.lineStyle(0);              
            //circle.graphics.beginFill( color , 0.5); 
            var matrix:Matrix = new Matrix(2*radius/img.width, 0, 0, 2*radius/img.height, -radius, -radius);
             
            circle.graphics.beginBitmapFill(bmd, matrix, true, true);              
            circle.graphics.drawCircle(x, y, radius);   
            circle.graphics.endFill();                                          
        } 
           
     }
}