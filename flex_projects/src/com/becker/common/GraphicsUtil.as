package  com.becker.common {
    
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextFormat;
import mx.core.UITextField;
import mx.graphics.ImageSnapshot;

public class GraphicsUtil  {    

    /** default text format */
    private static const TEXT_FORMAT:TextFormat = new TextFormat("Arial", 12, 0x000000, false);
    
    /** private constructor for static util class */
    //private function GraphicsUtil() {}
    
  
    /** 
     * draws text at rectangle location
     * @see http://stackoverflow.com/questions/1666127/can-i-set-text-on-a-flex-graphics-object
     */
    public static function drawText(x:int, y:int, text:String, 
                                    g:Graphics, format:TextFormat = null):void {
        var uit:UITextField = new UITextField();
        uit.text = text;
        
        uit.setTextFormat(format ? format : TEXT_FORMAT);
        uit.width = 4 + 16 * text.length;
        var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
        var matrix:Matrix = new Matrix();
      
        matrix.tx = x;
        matrix.ty = y;
        g.lineStyle(0, 0xdddd00, 0);            
        g.beginBitmapFill(textBitmapData, matrix, false);
        g.drawRect(x, y, uit.measuredWidth, uit.measuredHeight);
        g.endFill();
    }
    
}
}