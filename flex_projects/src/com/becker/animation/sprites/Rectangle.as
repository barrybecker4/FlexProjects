package  com.becker.animation.sprites {
    import Box2D.Common.Math.b2Vec2;
    import com.becker.common.Images;
    
    import flash.display.DisplayObject;
    
    //[Embed(source="../../../../assets/fonts/Agent Orange.ttf", fontName="agentFont", mimeType="application/x-font-truetype")]
    
    /**
     * Represents a 2D rectangle and common operations on it.
     * @author Barry Becker
     */
    public class Rectangle extends AbstractShape {
        
        private var img:DisplayObject;
        
        
        public function Rectangle(width:Number, height:Number, texture:Class = null) {
            super(0xaa77ff)
            this.width = width;
            this.height = height;
            img = texture ? new texture : new Images.GOLD;
            this.addChild(img);
            
            /*
            // this requires rotatable text
            var label:TextField = new TextField();
            //var formatter:TextFormat = new TextFormat("agentFont", 24);
            //label.styleSheet = new StyleSheet("../../../../assets/flexStyles.css";
            label.htmlText = "<font family='Times New Roman'>Hello</font>";
            //label.styleName = "agentFont"; 
            label.embedFonts = true;
            this.addChild(label);
            */
            
            init();
        }
   
        private function init():void {         
            img.x = x - width/2.0;
            img.y = y - height / 2.0;
            img.width = width;
            img.height = height;
            img.alpha = 0.8;
    
            graphics.lineStyle(0);
            //graphics.beginFill(color, 0.5);
            //var bitMap:BitMap = new Bitmap(new BitmapData(
            //graphics.beginBitmapFill(bitMap); 
            graphics.drawRect(x - width/2.0, y - height/2.0, width, height);
            //graphics.drawEllipse(xpos - width/3.0, ypos - height/3.0, width/4.0, height/4.0);
            //graphics.endFill();   
        }
     }
}