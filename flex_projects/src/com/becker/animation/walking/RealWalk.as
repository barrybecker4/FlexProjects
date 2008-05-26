package com.becker.animation.walking
{
    import com.becker.animation.Animatible;
    import com.becker.common.Segment;
    
    import flash.events.Event;
    import flash.geom.Point;
    
    import mx.core.UIComponent;

    public class RealWalk extends UIComponent implements Animatible
    {
        private var segment0:Segment;
        private var segment1:Segment;
        private var segment2:Segment;
        private var segment3:Segment;
        public static const DEFAULT_SPEED:Number = 0.12;
        private var speed:Number = DEFAULT_SPEED;
        
        public static const DEFAULT_THIGH_RANGE:Number = 45;
        private var thighRange:Number = DEFAULT_THIGH_RANGE;
        
        public static const DEFAULT_THIGH_BASE:Number = 90;
        private var thighBase:Number = DEFAULT_THIGH_BASE;
        
        public static const DEFAULT_CALF_RANGE:Number = 45;
        private var calfRange:Number = DEFAULT_CALF_RANGE;
        
        public static const DEFAULT_CALF_OFFSET:Number = -1.57;
        private var calfOffset:Number = DEFAULT_CALF_OFFSET;
        
        public static const DEFAULT_GRAVITY:Number = 0.2;
        private var gravity:Number = DEFAULT_GRAVITY;
        
        private var cycle:Number = 0;
        private var vx:Number = 0;
        private var vy:Number = 0;
        
        public function RealWalk()
        {}   
        
        public function startAnimating():void
        {            
            segment0 = new Segment(50, 15);
            addChild(segment0);
            segment0.x = 200;
            segment0.y = 100;
            
            segment1 = new Segment(50, 10);
            addChild(segment1);
            
            var rearPin0:Point = segment0.getRearPin();
            segment1.x = rearPin0.x;
            segment1.y = rearPin0.y;
            
            segment2 = new Segment(50, 15);
            addChild(segment2);
            segment2.x = 200;
            segment2.y = 100;
            
            segment3 = new Segment(50, 10);
            addChild(segment3);
            var rearPin3:Point = segment3.getRearPin();
            segment3.x = rearPin3.x;
            segment3.y = rearPin3.y;
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        public function setSpeed(v:Number):void
        {
            speed = v;
        }        
        public function setThighRange(v:Number):void
        {
            thighRange = v;
        }        
        public function setThighBase(v:Number):void
        {
            thighBase = v;
        }
        public function setCalfRange(v:Number):void
        {
            calfRange = v;
        }
        public function setCalfOffset(v:Number):void
        {
            calfOffset = v;
        }
        public function setGravity(v:Number):void
        {
            gravity = v;
        }
        
        private function onEnterFrame(event:Event):void
        {
            doVelocity();
            walk(segment0, segment1, cycle);
            walk(segment2, segment3, cycle + Math.PI);
            cycle += speed;
            checkFloor(segment1);
            checkFloor(segment3);
            checkWalls();
        }
        
        private function walk(segA:Segment, segB:Segment, cyc:Number):void
        {
            var foot:Point = segB.getRearPin();
            var angleA:Number = Math.sin(cyc) *
                                thighRange + 
                                thighBase;
            var angleB:Number = Math.sin(cyc + calfOffset) *
                                calfRange + calfRange;
            segA.rotation = angleA;
            segB.rotation = segA.rotation + angleB;
            
            segB.x = segA.getRearPin().x;
            segB.y = segA.getRearPin().y;
            segB.vx = segB.getRearPin().x - foot.x;
            segB.vy = segB.getRearPin().y - foot.y;
        }

        private function doVelocity():void
        {
            vy += gravity;
            segment0.x += vx;
            segment0.y += vy;
            segment2.x += vx;
            segment2.y += vy;
        }

        private function checkFloor(seg:Segment):void
        {
            var yMax:Number = seg.getBounds(this).bottom;
            if(yMax > this.height) 
            {
                var dy:Number = yMax -  this.height;
                segment0.y -= dy;
                segment1.y -= dy;
                segment2.y -= dy;
                segment3.y -= dy;
                vx -= seg.vx;
                vy -= seg.vy;
            }
        }
        
        private function checkWalls():void
        {
            var w:Number =  this.width + 200; 
            if(segment0.x > this.width + 100)
            {
                segment0.x -= w;
                segment1.x -= w;
                segment2.x -= w;
                segment3.x -= w;
            }
            else if(segment0.x < -100)
            {
                segment0.x += w;
                segment1.x += w;
                segment2.x += w;
                segment3.x += w;
            }
        }
    }
}
