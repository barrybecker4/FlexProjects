package com.becker.animation.box2d.interactors {
    
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * Handles the mouse move interations.
 * 
 * @author Barry Becker
 */
public class MouseMotionInteractor implements Interactor {
     
    private var owner:Sprite;
    private var _mouseMoveHandler:Function;

 
    /**
     * Constructor
     * @param owner the owning sprite for which we will handle mouse interation.
     */
    public function MouseMotionInteractor(owner:Sprite) {
        this.owner = owner;
          
        owner.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
    }
    
    public function removeHandlers():void {
        owner.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
    }
    
    /** must have the form of handler()  */
    public function set mouseMoveHandler(handler:Function):void {
        _mouseMoveHandler = handler;
    }
      
    /**
     * Respond key presses.
     */
    private function mouseMove(event:MouseEvent):void {
                 
        if (_mouseMoveHandler != null) {
            _mouseMoveHandler();
        }
    }
}
}