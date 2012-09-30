package  com.becker.animation.box2d {
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import Box2D.Dynamics.Joints.b2MouseJoint;
import Box2D.Dynamics.Joints.b2MouseJointDef;

import General.Input;

import com.becker.animation.sprites.AbstractShape;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;

/**
 * Handles the mouse interaction with the environment.
 * Allows one to throw around objects via an elastic tether.
 * 
 * @author Barry Becker
 */
public class MouseDragInteractor {
     
    private var owner:Sprite;
    private var world:b2World;
    private var mouseJoint:b2MouseJoint;
    private var mousePVec:b2Vec2 = new b2Vec2();
       
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
    public function MouseDragInteractor(owner:Sprite, world:b2World) {
        this.owner = owner;
        this.world = world;
            
        input = new Input(owner);
    }
      
    /**
     * Respond to user dragging of shapes.
     * @param timeStep time increment in simulation
     * @param scale scale factor of the physical objects in the world. 
     */
    public function handleMouseInteraction(timeStep:Number, scale:Number):void{
                 
        // Update mouse joint
        UpdateMouseWorld(scale)
        MouseDestroy();
        MouseDrag(timeStep);
        
        // Update input (last)
        Input.update();    
    }
    
    private function UpdateMouseWorld(scale:Number):void {
        var mouseWorld:Point = owner.globalToLocal(new Point(Input.mouseX, Input.mouseY));
        mouseWorldPhys = new Point(mouseWorld.x/scale, mouseWorld.y/scale); 
    }
    
    private function MouseDrag(timeStep:Number):void{
        // mouse press
        if (Input.mouseDown && draggedBody == null){
            startMouseDrag(timeStep);
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
    
    private function startMouseDrag(timeStep:Number):void {
        GetBodyAtMouse(mouseDragCallback);
    }
    
    private function mouseDragCallback(fixture:b2Fixture):void {
        if (fixture)
        {
            draggedBody = getBodyFromFixture(fixture);
            if (!mouseJoint) {
                var md:b2MouseJointDef = new b2MouseJointDef();
                
                md.bodyA = world.GetGroundBody();
                md.bodyB = draggedBody;
                md.target.Set(mouseWorldPhys.x, mouseWorldPhys.y);
                md.maxForce = 300.0 * draggedBody.GetMass();
                mouseJoint = world.CreateJoint(md) as b2MouseJoint;
                
                draggedBody.SetAwake(true);
            }     
        }
    }
    
    private function stopMouseDrag():void {
        if (mouseJoint) {
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
        var end:Point = new Point(Input.mouseX, Input.mouseY - 200); 
        
        var g:Graphics = owner.graphics;
        g.clear();
        g.lineStyle(2, 0xff8888);
        g.moveTo(start.x, start.y);
        g.lineTo(end.x, end.y);
        g.drawCircle(end.x, end.y, 4);
    }
          
    /** on mouse press */
    public function MouseDestroy():void{

        if (!Input.mouseDown && Input.isKeyPressed(68/*D*/)){
            GetBodyAtMouse(destroyCallback);
        }
    }   
    
    private function destroyCallback(fixture:b2Fixture):void {
        var body:b2Body = getBodyFromFixture(fixture);
        if (body)
        {
            owner.removeChild(body.GetUserData());
            world.DestroyBody(body);
        }
    }
    
    private function GetBodyAtMouse(queryCallback:Function):void {
        // Make a small box.
        mousePVec.Set(mouseWorldPhys.x, mouseWorldPhys.y);
        var aabb:b2AABB = new b2AABB();
        aabb.lowerBound.Set(mouseWorldPhys.x - 0.001, mouseWorldPhys.y - 0.001);
        aabb.upperBound.Set(mouseWorldPhys.x + 0.001, mouseWorldPhys.y + 0.001);
        
        // Query the world for overlapping shapes.
        var k_maxCount:int = 10;
        var shapes:Array = new Array();
        world.QueryAABB(queryCallback, aabb);
    } 
    
    public function getBodyFromFixture(fixture:b2Fixture):b2Body {
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