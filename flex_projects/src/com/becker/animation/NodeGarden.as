package com.becker.animation
{
    import com.becker.common.Ball;
    
    import flash.events.Event;
    
    import mx.core.UIComponent;

    public class NodeGarden extends UIComponent implements Animatible
    {
        private var particles:Array;
        private var numParticles:uint = 30;
        private var minDist:Number = 100;
        private var springAmount:Number = .003;
        
        public function NodeGarden()
        {
        }
        
        public function startAnimating():void
        {        
            particles = new Array();
            for(var i:uint = 0; i < numParticles; i++)
            {
                var particle:Ball = new Ball(5, 0xffffff);
                particle.x = Math.random() * this.width;
                particle.y = Math.random() * this.height;
                particle.xVelocity = Math.random() * 6 - 3;
                particle.yVelocity = Math.random() * 6 - 3;
                addChild(particle);
                particles.push(particle);
            }
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void
        {        
            for(var i:uint = 0; i < numParticles; i++)
            {
                var particle:Ball = particles[i];
                particle.x += particle.xVelocity;
                particle.y += particle.yVelocity;
                if(particle.x > this.width)
                {
                    particle.x = 0;
                }
                else if(particle.x < 0)
                {
                    particle.x = this.width;
                }
                if(particle.y > this.height)
                {
                    particle.y = 0;
                }
                else if(particle.y < 0)
                {
                    particle.y = stage.stageHeight;
                }
            }
              
            graphics.lineStyle(1, 0x0044cc);            
            for(i=0; i < numParticles - 1; i++)
            {
                var partA:Ball = particles[i];
                for (var j:uint = i + 1; j < numParticles; j++)
                {
                    var partB:Ball = particles[j];
                    spring(partA, partB);
                }
            }
        }
        
        private function spring(partA:Ball, partB:Ball):void
        {
            var dx:Number = partB.x - partA.x;
            var dy:Number = partB.y - partA.y;
            var dist:Number = Math.sqrt(dx * dx + dy * dy);
            
            if(dist < minDist)
            {                
                graphics.moveTo(partA.x, partA.y);
                graphics.lineTo(partB.x, partB.y);
                var ax:Number = dx * springAmount;
                var ay:Number = dy * springAmount;
                partA.xVelocity += ax;
                partA.yVelocity += ay;
                partB.xVelocity -= ax;
                partB.yVelocity -= ay;
            }            
        }
    }
}
