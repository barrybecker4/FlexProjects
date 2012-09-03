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
 * 
 * @author Barry Becker
 */
public class MouseInteractor {
     
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
    public function MouseInteractor(owner:Sprite, world:b2World) {
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
        var body:b2Body = GetBodyAtMouse();
        if (body)
        {
            draggedBody = body;
            if (!mouseJoint) {
                var md:b2MouseJointDef = new b2MouseJointDef();
                
                md.body1 = world.GetGroundBody();
                md.body2 = draggedBody;
                md.target.Set(mouseWorldPhys.x, mouseWorldPhys.y);
                md.maxForce = 300.0 * draggedBody.GetMass();
                md.timeStep = timeStep;
                mouseJoint = world.CreateJoint(md) as b2MouseJoint;
                
                draggedBody.WakeUp(); 
            }     
        }
    }
    
    private function stopMouseDrag():void {
        if (mouseJoint) {
            //this.removeChild(mouseJoint.GetUserData());
            draggedBody = null;
            world.DestroyJoint(mouseJoint);
            
            mouseJoint = null;
            owner.graphics.clear();
        }
    }
        
    private function dragJoint():void {
        var p2:b2Vec2 = new b2Vec2(mouseWorldPhys.x, mouseWorldPhys.y);
        mouseJoint.SetTarget(p2);
        
        //var v:b2Vec2 = .GetLocalCenter();
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
            
    public function MouseDestroy():void{
        // mouse press
        if (!Input.mouseDown && Input.isKeyPressed(68/*D*/)){
            
            var body:b2Body = GetBodyAtMouse(true);
            
            if (body)
            {
                owner.removeChild(body.GetUserData());
                world.DestroyBody(body);
                return;
            }
        }
    }   
    
    public function GetBodyAtMouse(includeStatic:Boolean=false):b2Body {
        // Make a small box.
        mousePVec.Set(mouseWorldPhys.x, mouseWorldPhys.y);
        var aabb:b2AABB = new b2AABB();
        aabb.lowerBound.Set(mouseWorldPhys.x - 0.001, mouseWorldPhys.y - 0.001);
        aabb.upperBound.Set(mouseWorldPhys.x + 0.001, mouseWorldPhys.y + 0.001);
        
        // Query the world for overlapping shapes.
        var k_maxCount:int = 10;
        var shapes:Array = new Array();
        var count:int = world.Query(aabb, shapes, k_maxCount);
        var body:b2Body = null;
        for (var i:int = 0; i < count; ++i) {
            
            if (b2Body(shapes[i].GetBody()).IsStatic() == false || includeStatic) {
                
                var tShape:b2Shape = shapes[i] as b2Shape;
                var inside:Boolean = tShape.TestPoint(tShape.GetBody().GetXForm(), mousePVec);
                if (inside)
                {
                    body = tShape.GetBody();
                    break;
                }
            }
        }
        return body;
    } 
}
}