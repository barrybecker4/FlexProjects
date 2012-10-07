package  com.becker.animation.box2d.interactors {
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import Box2D.Dynamics.Joints.b2MouseJoint;
import Box2D.Dynamics.Joints.b2MouseJointDef;
import flash.display.Stage;

import General.Input;

import com.becker.animation.sprites.AbstractShape;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import flash.events.KeyboardEvent;

/**
 * Handles the keboard actions.
 * 
 * @author Barry Becker
 */
public class KeyboardInteractor implements Interactor {
     
    private var owner:Sprite;
    
    /** mouse input. */
    private var input:Input;
    
    private var _keyPressHandler:Function;

 
    /**
     * Constructor
     * @param owner the owning sprite for which we will handle mouse interation.
     * @param world the physical world instance.
     */
    public function KeyboardInteractor(owner:Sprite) {
        this.owner = owner;
          
        owner.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPress, false, 0, true);
        owner.stage.addEventListener(KeyboardEvent.KEY_UP, keyRelease, false, 0, true);
    }
    
    public function removeHandlers():void {
        owner.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPress);
        owner.stage.removeEventListener(KeyboardEvent.KEY_UP, keyRelease);
    }
    
    /** must have the form of handler(keyCode:uint)  */
    public function set keyPressHandler(handler:Function):void {
        _keyPressHandler = handler;
    }
      
    /**
     * Respond key presses.
     */
    private function keyPress(event:KeyboardEvent):void {
                 
        if (_keyPressHandler != null) {
            _keyPressHandler(event.keyCode);
        }
    }
    
    private function keyRelease(event:KeyboardEvent):void {
    }
    
}
}