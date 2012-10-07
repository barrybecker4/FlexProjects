package  com.becker.animation.sprites {
    
    import com.becker.common.Images;
    import flash.display.Graphics;
    
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
        private var imageClass:Class;
        
               
        public function Circle(radius:Number, image:Class = null, color:uint = 0x9988cc) {
            super(color);
            this.radius = radius;
            this.imageClass = image;
            circle = new Shape(); 
            addChild(circle);
            
            init();
        }
         
        protected function init():void {
            
            var g:Graphics = circle.graphics;
            
            if (imageClass) {
                var img:DisplayObject = new imageClass;
                var bmd:BitmapData = new BitmapData(img.width, img.height, true, 0x224466);
                bmd.draw(img);
        
                var matrix:Matrix = 
                    new Matrix(2 * radius / img.width, 0, 0, 
                               2 * radius / img.height, 
                               -radius, -radius);
                 
                g.lineStyle(0);           
                g.beginBitmapFill(bmd, matrix, true, true);              
            }
            else {
                g.lineStyle(1); 
                g.beginFill(color , 0.6); 
            }
            g.drawCircle(x, y, radius);   
            g.endFill();     
            
            g.moveTo(0, 0);
            g.lineTo(radius, 0);
            //g.moveTo(0, -radius);
            //g.lineTo(0, radius);
        } 
           
     }
}