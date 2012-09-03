package  com.becker.animation.box2d {
    
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Contacts.b2ContactResult;
    
    import com.becker.common.Sounds;
    
    public class ContactListener extends b2ContactListener {

        /**
         * Called when a contact point is added. This includes the geometry
         * and the forces.
         */
        override public function Add(point:b2ContactPoint):void {
            var normVel:Number = point.velocity.Normalize();
            //var volume:Number = (normVel * normVel)/100;
            var volume:Number = normVel/10;
            //trace("sep = " + point.separation)
            if (volume > 0) {
                //trace("new contact vol=" + volume);            
                Sounds.playHit(volume);
            }
        };
    
        /** 
         * Called when a contact point persists. This includes the geometry
         * and the forces.
         */
        override public function Persist(point:b2ContactPoint):void {
            //trace("persist");
            //Sounds.playScrape();
        }
    
        /** 
         * Called when a contact point is removed. This includes the last
         * computed geometry and forces.
         */
        override public virtual function Remove(point:b2ContactPoint):void {
        };
        
        /**
         * Called after a contact point is solved.
         */
        override public virtual function Result(point:b2ContactResult):void {
        };
    }



}