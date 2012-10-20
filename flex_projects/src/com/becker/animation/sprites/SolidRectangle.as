package  com.becker.animation.sprites {
    import Box2D.Common.Math.b2Vec2;
    import com.becker.common.Images;
    
    import flash.display.DisplayObject;
    
    //[Embed(source="../../../../assets/fonts/Agent Orange.ttf", fontName="agentFont", mimeType="application/x-font-truetype")]
    
    /**
     * Represents a 2D rectangle and common operations on it.
     * @author Barry Becker
     */
    public class SolidRectangle extends AbstractShape {
        
        public function SolidRectangle(width:Number, height:Number, color:uint = 0xaa77ff) {
            super(color)
            this.width = width;
            this.height = height;
            init();
        }
   
        private function init():void {         
            img.x = x - width/2.0;
            img.y = y - height / 2.0;
            img.width = width;
            img.height = height;
            //img.alpha = 0.8;
    
            graphics.lineStyle(0);
            graphics.beginFill(color, 0.5);
            //var bitMap:BitMap = new Bitmap(new BitmapData(
            //graphics.beginBitmapFill(bitMap); 
            graphics.drawRect(x - width/2.0, y - height/2.0, width, height);
            graphics.endFill();   
        }
     }
}