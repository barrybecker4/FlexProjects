package com.becker.animation
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.DropShadowFilter;
    
    import mx.containers.VBox;
    import mx.core.UIComponent;
    
    public class AnimatedFilters extends UIComponent implements Animatible
    {
        private var filter:DropShadowFilter;
        private var sprite:Sprite;
        
        private var origWidth:Number = 1;
        private var origHeight:Number = 1;
        
        public function AnimatedFilters() {
        }
        
        public function startAnimating():void
        {
            origWidth = this.width;
            origHeight = this.height;
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            this.invalidateDisplayList();
        }
        
        override protected function createChildren():void {
            sprite = new UIComponent();
            addChild(sprite);
            
            filter = new DropShadowFilter(0, 0, 0, 1, 20, 20, .3);
        }
        
        override protected function updateDisplayList(w:Number, h:Number):void {
            super.updateDisplayList(w, h);
            
            var xscale:Number = this.width / origWidth;
            var yscale:Number = this.height / origHeight;
            var scale:Number = Math.min(xscale, yscale);

            sprite.graphics.clear();
            sprite.graphics.lineStyle(2);
            sprite.graphics.beginFill(0xffff00);
            sprite.graphics.drawRect(-50.0 * xscale, -50.0 * yscale, 100.0 * xscale, 100.0 * yscale);
            sprite.graphics.endFill();
            sprite.x = 200 * xscale;
            sprite.y = 100 * yscale;
        }
        
        
        private function onEnterFrame(event:Event):void
        {    
            var dx:Number = mouseX - sprite.x;
            var dy:Number = mouseY - sprite.y;
            
            filter.distance = -Math.sqrt(dx * dx + dy * dy) / 10;
            filter.angle = Math.atan2(dy, dx) * 180 / Math.PI;
            sprite.filters = [filter];
        }
    }
}
