package  com.becker.animation.threed {
    import com.becker.animation.sprites.AbstractShape;
    import flash.display.Sprite;
    
    /**
     * Represents a 3D space and common operations on it.
     */
    public class Ball3D extends AbstractShape {
        
        public var radius:Number;
        public var xpos:Number = 0;
        public var ypos:Number = 0;
        public var zpos:Number = 0;
        public var vx:Number = 0;
        public var vy:Number = 0;
        public var vz:Number = 0;
        public var mass:Number = 1;
        
        public function Ball3D(radius:Number=40, color:uint=0xff0000) {
            this.radius = radius;
            this.color = color;
            init();
        }
        
        public function init():void {
            graphics.lineStyle(0);
            graphics.beginFill(color);
            graphics.drawCircle(0, 0, radius);
            graphics.endFill();
        }
            
        /**
         * @param room dimensions of 3d room
         * @param fl
         */
        public function bounce(elasticity:Number,
                               gravity:Number, room:Room, 
                               clip:ClippingPlane):void {
                                   
            var radius:Number =  radius;
            
            xpos += vx;
            ypos += vy;
            zpos += vz;
            
            if (xpos + radius > room.right) {
                xpos = room.right - radius;
                vx *= -elasticity;
            }
            else if (xpos - radius < room.left) {
                xpos = room.left + radius;
                vx *= -elasticity;
            }
            if (ypos + radius > room.bottom) {
                ypos = room.bottom - radius;
                vy *= -elasticity;
            }
            else if (ypos - radius < room.top) {
                ypos = room.top + radius;
                vy *= -elasticity;
            }
            if (zpos + radius > room.front) {
                zpos = room.front - radius;
                vz *= -elasticity;
            }
            else if(zpos - radius < room.back) {
                zpos = room.back + radius;
                vz *= -elasticity;
            }
            
            if (zpos > -clip.fl) {
                var scale:Number = clip.fl / (clip.fl + zpos);
                scaleX = scaleY = scale;
                x = clip.vpX + xpos * scale;
                y = clip.vpY + ypos * scale;
                visible = true;
            }
            else {
                visible = false;
            }
        }
     }
}