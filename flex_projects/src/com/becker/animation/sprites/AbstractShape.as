package  com.becker.animation.sprites {
    
    import mx.core.UIComponent;
    
    /**
     * Represents a 2D ball and common operations on it.
     */
    public class AbstractShape extends UIComponent {
        
         protected var color:uint;
        
         public function AbstractShape(color:uint = 0x9988cc) {

             this.color = color;     
         }                 
     }
}