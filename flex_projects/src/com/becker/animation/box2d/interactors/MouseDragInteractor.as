package  com.becker.animation.box2d.interactors {
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import Box2D.Dynamics.Joints.b2MouseJoint;
import Box2D.Dynamics.Joints.b2MouseJointDef;
import com.becker.animation.sprites.AbstractShape;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import General.Input;


/**
 * Handles the mouse interaction with the environment.
 * Allows one to throw around objects via an elastic tether.
 * 
 * @author Barry Becker
 */
public class MouseDragInteractor implements Interactor {
     
    /** Max amount of force the tether will exert when dragging. Should be passed to constructor. */
    private static const DRAG_FORCE:Number = 300;
    
    /** accounts for UI controls that may be at the top of the application window and any padding. */
    private static const OFFSET:Point = new Point(10, 190);
    
    private var owner:Sprite;
    private var world:b2World;
    private var scale:Number;
    private var mouseJoint:b2MouseJoint;
       
    /** world mouse position. */
    private static var mouseWorldPhys:Point;
    
    /** mouse input. */
    private var input:Input;

    /** The current body being dragged by the mouse, if any. */
    private var draggedBody:b2Body;
 
    /**
     * Constructor
     * @param owner the owning sprite for which we will handle mouse interation.
     * @param world the physical world instance.
     */
    public function MouseDragInteractor(owner:Sprite, world:b2World, scale:Number) {
        this.owner = owner;
        this.world = world;
        this.scale = scale;
            
        input = new Input(owner);
        owner.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseInteraction);
    }
    
    public function removeHandlers():void {
        owner.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseInteraction);
    }
      
    /** Respond to user dragging of shapes. */
    private function handleMouseInteraction(event:MouseEvent):void {
                 
        // Update mouse joint
        updateMouseWorld(scale)
        mouseDestroy();
        mouseDrag();
        
        // Update input (last)
        Input.update();    
    }
    
    /** determine the new scaled location of the mouse's scaled world corrdinates */
    private function updateMouseWorld(scale:Number):void { 
        var mousePoint:Point = new Point(Input.mouseX + owner.x, Input.mouseY + owner.y);
        var mouseWorld:Point = owner.globalToLocal(mousePoint);
        mouseWorldPhys = new Point(mouseWorld.x / scale, mouseWorld.y / scale); 
    }
    
    private function mouseDrag():void{
        // mouse press
        if (Input.mouseDown && draggedBody == null){
            startMouseDrag();
        }       
      
        // mouse release
        if (!Input.mouseDown){
            stopMouseDrag();
        }
                
        // mouse move
        if (mouseJoint) {
            dragJoint();
        }
    }
    
    private function startMouseDrag():void {
        getBodyAtMouse(mouseDragCallback);
    }
    
    /** Called when something is dragged. Make it a bullet to avoid tunneling. */
    private function mouseDragCallback(fixture:b2Fixture):void {
        if (fixture)
        {
            draggedBody = getBodyFromFixture(fixture);
            draggedBody.SetBullet(true);
            if (!mouseJoint && draggedBody) {
                var mouseJointDef:b2MouseJointDef = new b2MouseJointDef();
                
                mouseJointDef.bodyA = world.GetGroundBody();
                mouseJointDef.bodyB = draggedBody;
                mouseJointDef.target.Set(mouseWorldPhys.x, mouseWorldPhys.y);
                mouseJointDef.maxForce = DRAG_FORCE * draggedBody.GetMass();
                mouseJoint = world.CreateJoint(mouseJointDef) as b2MouseJoint;
                
                draggedBody.SetAwake(true);
            }     
        }
    }
    
    private function stopMouseDrag():void {
        if (mouseJoint) {
            draggedBody.SetBullet(false);
            draggedBody = null;
            world.DestroyJoint(mouseJoint);
            
            mouseJoint = null;
            owner.graphics.clear();
        }
    }
        
    private function dragJoint():void {
        var p2:b2Vec2 = new b2Vec2(mouseWorldPhys.x, mouseWorldPhys.y);
        mouseJoint.SetTarget(p2);
        
        var shape:AbstractShape = AbstractShape(draggedBody.GetUserData());
        var start:Point = new Point(shape.x, shape.y); 
        var end:Point = new Point(Input.mouseX - OFFSET.x, Input.mouseY - OFFSET.y); 
        
        drawTether(start, end);
    }
    
    /**  Query the world for overlapping shapes. */
    private function getBodyAtMouse(queryCallback:Function):void {
        world.QueryAABB(queryCallback, createBBoxAtMouse());
    } 
    
    /**  Make a small selection box at the location of the mouse. */
    private function createBBoxAtMouse():b2AABB {
        var bbox:b2AABB = new b2AABB();
        var x:Number =  mouseWorldPhys.x;
        var y:Number =  mouseWorldPhys.y;
        bbox.lowerBound.Set(x - 0.001, y - 0.001);
        bbox.upperBound.Set(x + 0.001, y + 0.001);
        return bbox;
    }
    
    /** connects the mouse location to the dragged body */
    private function drawTether(start:Point, end:Point):void {
        var g:Graphics = owner.graphics;
        g.clear();
        g.lineStyle(2, 0xff8888);
        g.moveTo(start.x, start.y);
        g.lineTo(end.x, end.y);
        g.drawCircle(end.x, end.y, 4);
    }
          
    /** on mouse press */
    public function mouseDestroy():void{

        if (!Input.mouseDown && Input.isKeyPressed(68/*D*/)){
            getBodyAtMouse(destroyCallback);
        }
    }   
    
    /** removes and destroys the currently dragged body. */
    private function destroyCallback(fixture:b2Fixture):void {
        var body:b2Body = getBodyFromFixture(fixture);
        if (body) {
            owner.removeChild(body.GetUserData());
            world.DestroyBody(body);
        }
    }
    
    /** figure out which body the selected fixture is attache dto */
    private function getBodyFromFixture(fixture:b2Fixture):b2Body {
        var body:b2Body = null;
        if (fixture) {
            if (b2Body(fixture.GetBody()).GetType() != b2Body.b2_staticBody) {
                
                body = fixture.GetBody();
            }
        }
        return body;
    }
}
}