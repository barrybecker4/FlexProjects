package  com.becker.animation.box2d {
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import Box2D.Dynamics.Joints.b2MouseJoint;
import Box2D.Dynamics.Joints.b2MouseJointDef;

import General.Input;

import com.becker.animation.Animatible;
import com.becker.animation.box2d.simulations.BridgeSimulation;
import com.becker.animation.box2d.simulations.HelloWorldSimulation;
import com.becker.animation.box2d.simulations.RagDollSimulation;
import com.becker.animation.box2d.simulations.TheoJansenSimulation;
import com.becker.animation.sprites.AbstractShape;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

import mx.core.UIComponent;
import mx.events.ResizeEvent;

/**
 * The simulated world of shapes interacting with the users mouse and the environment.
 * 
 * ideas todo:
 *  - show force line when dragging objects
 *  - simplify simple shape consturction to include position.
 *  - make scene scale with window resize.
 *  - make game
 */
public class BoxWorld extends UIComponent implements Animatible {
	
	private var world:b2World;
	
	private var simulation:Simulation;
	
    private static const NUM_ITERATIONS:int = 10;
    private static const TIME_STEP:Number = 1.0/20.0;      
    private static const ORIG_WIDTH:int = 1200;
    
    [Bindable]
    public var gravity:Number = 9.8;
    
    [Bindable]
    public var friction:Number = 0.5;
    
    [Bindable]
    public var density:Number = 1.0;  
	
    [Bindable]
    public var restitution:Number = 0.2;
    
    private var _enableSimulation:Boolean = true;
    
    private var showDebug:Boolean = false;
    private var debugSprite:Sprite;
   
 
    public var mouseJoint:b2MouseJoint;
    private var mousePVec:b2Vec2 = new b2Vec2();
   
    /** world mouse position. */
    private static var mouseWorldPhys:Point;
    private var firstTime:Boolean = true;
    
    /** mouse input. */
    private var input:Input;

    /** The current body being dragged by the mouse, if any. */
    private var draggedBody:b2Body;
    
    /** some different demos to select from */
     public static const AVAILABLE_SIMULATIONS:Array = [
           "Hello World", "Rag Doll", "Bridge", "Theo Jansen Spider" 
     ];    
    
    /**
     * Constructor
     */
    public function BoxWorld() {
    }
    
    /**
     * @param the name of a class that implements Simulation
     */
    public function setSimulation(simulationName:String):void {
    	world = createWorld();  
    	switch (simulationName) {
            case AVAILABLE_SIMULATIONS[0]: 
                simulation = new HelloWorldSimulation(world, this, density, friction, restitution); break;
            case AVAILABLE_SIMULATIONS[1]: 
                simulation = new RagDollSimulation(world, this, density, friction, restitution); break;
            case AVAILABLE_SIMULATIONS[2]: 
                simulation = new BridgeSimulation(world, this, density, friction, restitution); break;
            case AVAILABLE_SIMULATIONS[3]: 
                simulation = new TheoJansenSimulation(world, this, density, friction, restitution); break;
            default: throw new Error("Unexpected sim :" + simulationName);
        }       
    	startAnimation();    	
    }
    
    public function startAnimating():void {
    	if (world == null) {
    		setSimulation(AVAILABLE_SIMULATIONS[0]);
    	}
    }
    
    public function startAnimation():void {
                          
        this.removeChildren();
        addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
        addEventListener(ResizeEvent.RESIZE, resized, false, 0, true);
               
        world.SetContactListener(new ContactListener());    
        if (showDebug)     
            addDebugDrawing();
        
        simulation.addStaticElements();           
        simulation.addDynamicElements();       
    }
    
    private function resized(evt:ResizeEvent):void {
    	var oldWidth:int = evt.oldWidth;
    	
    	//var scale:Number = Number(this.width) / ORIG_WIDTH;
    	//trace("w="+this.width +" s="+scale);
    	//this.stage.scaleX = scale;
    	//this.stage.scaleY = scale;
    	//this.stage.stageWidth = this.width;
    	//this.stage.stageHeight = this.height;
    }
    
    [Bindable]
    public function get enableSimulation():Boolean {
    	return _enableSimulation; 
    }
    
    public function set enableSimulation(enable:Boolean):void {
    	if (enable) {
    	    addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
    	} else {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        _enableSimulation = enable;
    }
      
    private function removeChildren():void
    {  
    	for (var i:int=this.numChildren-1; i>=0; i--) {
    		this.removeChildAt(i);
    	}
    } 
    
    public function onEnterFrame(e:Event):void{
    	  
       if (firstTime && enableSimulation && this.stage != null) {
            input = new Input(this); 
            firstTime = false;
        }
        
        world.Step(TIME_STEP, NUM_ITERATIONS);
        
        // Go through body list and update sprite positions/rotations
        
        for (var bb:b2Body = world.m_bodyList; bb; bb = bb.m_next){
            if (bb.m_userData is AbstractShape) {
                bb.m_userData.x = bb.GetPosition().x * simulation.scale;
                bb.m_userData.y = bb.GetPosition().y * simulation.scale ;
                bb.m_userData.rotation = bb.GetAngle() * (180/Math.PI);
            }
        } 
        
        // Update mouse joint
        UpdateMouseWorld()
        MouseDestroy();
        MouseDrag();
        
        // Update input (last)
        Input.update();    
    }
    
    private function UpdateMouseWorld():void {
    	var mouseWorld:Point = this.globalToLocal(new Point(Input.mouseX, Input.mouseY));
        mouseWorldPhys = new Point(mouseWorld.x/simulation.scale, mouseWorld.y/simulation.scale); 
    }
    
    public function MouseDrag():void{
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
				md.timeStep = TIME_STEP;
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
			this.graphics.clear();
		}
	}
		
	private function dragJoint():void {
		var p2:b2Vec2 = new b2Vec2(mouseWorldPhys.x, mouseWorldPhys.y);
		mouseJoint.SetTarget(p2);
		
		//var v:b2Vec2 = .GetLocalCenter();
		var start:Point = new Point(draggedBody.GetUserData().x, draggedBody.GetUserData().y );
		var end:Point = new Point(Input.mouseX, Input.mouseY - 200); 
		
		this.graphics.clear();
		this.graphics.lineStyle(2, 0xff8888);
		this.graphics.moveTo(start.x, start.y);
		this.graphics.lineTo(end.x, end.y);
		this.graphics.drawCircle(end.x, end.y, 4);
	}
		    
    public function MouseDestroy():void{
        // mouse press
        if (!Input.mouseDown && Input.isKeyPressed(68/*D*/)){
            
            var body:b2Body = GetBodyAtMouse(true);
            
            if (body)
            {
            	removeChild(body.GetUserData());
                world.DestroyBody(body);
                return;
            }
        }
    }
    
    
    public function GetBodyAtMouse(includeStatic:Boolean=false):b2Body{
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
    
    private function createWorld():b2World {
    	// Create world AABB
        var worldAABB:b2AABB = new b2AABB();
        worldAABB.lowerBound.Set(-100.0, -100.0);
        worldAABB.upperBound.Set(100.0, 100.0);
        var gravity:b2Vec2 = new b2Vec2(0.0, gravity);
        var doSleep:Boolean = true;
        return new b2World(worldAABB, gravity, doSleep);
    }
    
      
    public function set showForces(show:Boolean):void {
    	if (show) {
            addDebugDrawing();
        }
        else {
        	removeDebugDrawing();
        }
    }
    
    public function set showVelocities(show:Boolean):void {
        showForces = show;
    }
    
    private function addDebugDrawing():void {
    	// if already showing debug, dont do it again.
    	if (!showDebug) {
            var dbgDraw:b2DebugDraw = new b2DebugDraw();
            debugSprite = new Sprite();
            addChild(debugSprite);
            dbgDraw.m_sprite = debugSprite;
            dbgDraw.m_drawScale = simulation.scale;
            dbgDraw.m_fillAlpha = 0.4;
            dbgDraw.m_lineThickness = 2.0;
            dbgDraw.m_drawFlags = 0xFFFFFFFF;
            world.SetDebugDraw(dbgDraw);
            world.DrawDebugData();
            showDebug = true;
        }
    }
    
    private function removeDebugDrawing():void {     
    	if (showDebug) {  
    		removeChild(debugSprite);   
            world.SetDebugDraw(null); 
            showDebug = false;
        }           
    }
}
}