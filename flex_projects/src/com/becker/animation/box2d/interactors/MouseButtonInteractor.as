package com.becker.animation.box2d.interactors {
    
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import flash.display.Sprite;
import flash.events.MouseEvent;


/**
 * Handles mouse button clicks.
 * 
 * @author Barry Becker
 */
public class MouseButtonInteractor implements Interactor {
     
    private var owner:Sprite;
    private var _buttonPressHandler:Function;
    private var _buttonReleaseHandler:Function;

 
    /**
     * Constructor
     * @param owner the owning sprite for which we will handle mouse interation.
     */
    public function MouseButtonInteractor(owner:Sprite) {
        this.owner = owner;
          
        owner.stage.addEventListener(MouseEvent.MOUSE_DOWN, buttonPress, false, 0, true);
        owner.stage.addEventListener(MouseEvent.MOUSE_UP, buttonRelease, false, 0, true);
    }
    
    public function removeHandlers():void {
        owner.stage.removeEventListener(MouseEvent.MOUSE_DOWN, buttonPress);
        owner.stage.removeEventListener(MouseEvent.MOUSE_UP, buttonRelease);
    }
    
    /** must have the form of handler()  */
    public function set buttonPressHandler(handler:Function):void {
        _buttonPressHandler = handler;
    }
    
    /** must have the form of handler()  */
    public function set buttonReleaseHandler(handler:Function):void {
        _buttonReleaseHandler = handler;
    }
      
    /**
     * Respond key presses.
     */
    private function buttonPress(event:MouseEvent):void {
                 
        if (_buttonPressHandler != null) {
            _buttonPressHandler();
        }
    }
    
    private function buttonRelease(event:MouseEvent):void {
        if (_buttonReleaseHandler != null) {
            _buttonReleaseHandler();
        }
    }
    
}
}