package com.becker.animation.box2d.builders {
    
    import Box2D.Collision.*;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2ContactListener;
    import Box2D.Dynamics.Contacts.b2Contact;
    import com.becker.animation.box2d.builders.items.Cannon;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    /**
     * Identifies when the base dof the cannon is in contact with the ground.
     * @author Barry Becker
     */
    public class CannonContactListener extends b2ContactListener {

        public static const CANNON_START_CONTACT:String = "cannonStartContact";
        public static const CANNON_STOP_CONTACT:String = "cannonStopContact";
        public var eventDispatcher:EventDispatcher;
        
        public function CannonContactListener() {
            eventDispatcher = new EventDispatcher();
        }
        
        /**
         * Called when a contact contact.is added. This includes the geometry
         * and the forces.
         */ 
        override public function BeginContact(contact:b2Contact):void {

            var body1:b2Body = contact.GetFixtureA().GetBody();
            var body2:b2Body = contact.GetFixtureB().GetBody();
            if (body1.GetUserData() && body2.GetUserData() ) {
                body1.GetUserData().alpha = 0.8;
                body2.GetUserData().alpha = 0.8;
               
                if (isCannon(contact)) {
                    trace("begin contact with cannon");
                    eventDispatcher.dispatchEvent(new Event(CANNON_START_CONTACT));
                }
            }
            else {
                trace("error in BeginContact : " + contact.GetFixtureA() + " or " + contact.GetFixtureB() + " has no userData. b1="+ body1.GetUserData() + " b2="+ body2.GetUserData());
            }
        }
 
        /**
         * Called when a contact contact is removed. This includes the last
         * computed geometry and forces.
         */ 
        override public function EndContact(contact:b2Contact):void {
            var body1:b2Body = contact.GetFixtureA().GetBody();
            var body2:b2Body = contact.GetFixtureB().GetBody();
            if (body1 && body1.GetUserData() && body2 && body2.GetUserData() ) {
                body1.GetUserData().alpha = 1.0;
                body2.GetUserData().alpha = 1.0;
                
                if (isCannon(contact)) {
                    //trace("end contact with cannon");
                    eventDispatcher.dispatchEvent(new Event(CANNON_STOP_CONTACT));
                }
            }
            else {
                trace("error in EndContact : " + contact.GetFixtureA() + " or " + contact.GetFixtureB() + " has no userData. b1="+ body1.GetUserData() + " b2="+ body2.GetUserData());
            }
        }
        
        private function isCannon(contact:b2Contact):Boolean {
            return contact.GetFixtureA().GetUserData() == Cannon.GROUND_SENSOR 
                     || contact.GetFixtureB().GetUserData()== Cannon.GROUND_SENSOR;
        }
    }
}

