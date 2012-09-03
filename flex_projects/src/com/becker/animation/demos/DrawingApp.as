package com.becker.animation.demos
{
	import com.becker.animation.Animatible;
    import flash.events.MouseEvent;
    
    import mx.core.UIComponent;
    
    public class DrawingApp extends UIComponent implements Animatible {
		
        public function DrawingApp() {}
        
        public function startAnimating():void {
            graphics.lineStyle(1);
            this.parent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            this.parent.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
        
        private function onMouseDown(event:MouseEvent):void {
            graphics.moveTo(mouseX, mouseY);
            this.parent.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        
        private function onMouseUp(event:MouseEvent):void {
            this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }
        
        private function onMouseMove(event:MouseEvent):void {
            graphics.lineTo(mouseX, mouseY);
        }
    }
}
