package  com.becker.animation.box2d {
    
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    import Box2D.Dynamics.Contacts.b2Contact;
    import Box2D.Dynamics.Contacts.b2ContactResult;
    
    import com.becker.common.Sounds;
    
    public class ContactListener extends b2ContactListener {

        /**
         * Called when a contact point is added. This includes the geometry
         * and the forces.
         */
        override public function BeginContact(point:b2Contact):void {
            //var normVel:Number = point.velocity.Normalize();
            //var volume:Number = (normVel * normVel)/100;
            var volume:Number = 0.1 + Math.random() / 5.0; // normVel / 10;
            //trace("sep = " + point.separation)
            if (volume > 0) {
                //trace("new contact vol=" + volume);            
                Sounds.playScrape(volume);
            }
        };
        
        /**
         * Called when a contact point is added. This includes the geometry
         * and the forces.
         */
        override public function PostSolve(point:b2Contact, impulse:b2ContactImpulse):void {
            var sum:Number = 0;
            for each (var imp:Number in impulse.normalImpulses) {
                sum += imp;
            }
     
            var volume:Number = sum/60.0;
            if (volume > 0) {
                //trace("new contact vol=" + volume); 
                //Sounds.playScrape(volume);
                Sounds.playHit(volume);
            }
        };  
    }

}