package  com.becker.animation.box2d.interactors {
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import General.Input;

/**
 * Handles the keboard actions.
 * 
 * @author Barry Becker
 */
public class KeyboardInteractor implements Interactor {
     
    private var owner:Sprite;
    private var _keyPressHandler:Function;
    private var _keyReleaseHandler:Function;

 
    /**
     * Constructor
     * @param owner the owning sprite for which we will handle keyboard interation.
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
    
    /** must have the form of handler(keyCode:uint)  */
    public function set keyReleaseHandler(handler:Function):void {
        _keyReleaseHandler = handler;
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
        if (_keyReleaseHandler != null) {
            _keyReleaseHandler(event.keyCode);
        }
    }
    
}
}