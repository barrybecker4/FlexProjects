package com.becker.animation
{
    import flash.display.Sprite;
    import flash.events.Event;
    
    public class Scribble extends UIComponent implements Animatible
    {
        private var numPoints:uint = 9000;
        
        private var points:Array = new Array();
        
        private var counter:int = 0;
        
        public function Scribble()
        {
        }
        
        public function startAnimating():void
        {
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            
            
            for (var i:int = 0; i < numPoints; i++)
            {
                points[i] = new Object();
                points[i].x = Math.random() * stage.stageHeight;
                points[i].y = Math.random() * stage.stageHeight;
            }
            // find the first midpoint and move to it
            var xc1:Number = (points[0].x + points[numPoints - 1].x) / 2;
            var yc1:Number = (points[0].y + points[numPoints - 1].y) / 2;
            graphics.lineStyle(1);
            graphics.moveTo(xc1, yc1);
            
            counter = 0;
       }
       
       private function onEnterFrame(evt:Event):void
       {
  
            var i:int = counter++;
            
            var xc:Number = (points[i].x + points[i + 1].x) / 2;
            var yc:Number = (points[i].y + points[i + 1].y) / 2;
            graphics.curveTo(points[i].x, points[i].y, xc, yc);            
            
            
            
            // curve through the last point, back to the first midpoint
            //graphics.curveTo(points[i].x, points[i].y, xc1, yc1);
            
        }
    }
}
