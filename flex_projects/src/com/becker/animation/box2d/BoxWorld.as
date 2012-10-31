package  com.becker.animation.box2d {
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import Box2D.Dynamics.Joints.b2Joint;
import com.becker.animation.Animatible;
import com.becker.animation.sprites.AbstractShape;
import com.becker.animation.sprites.Line;
import com.becker.common.PhysicalParameters;
import com.becker.common.Util;
import flash.display.Sprite;
import flash.events.Event;
import mx.core.UIComponent;
import mx.events.ResizeEvent;

/**
 * The artificial world that will host a simulation.
 * The simulation that is set on the word defines what will be shown in it.
 * 
 * @author Barry Becker
 */
public class BoxWorld extends UIComponent implements Animatible {
    
    private var world:b2World;
    private var simulation:Simulation;
    
    private static const VELOCITY_ITERATIONS:int = 10;
    private static const STEP_ITERATIONS:int = 6;
    private static const TIME_STEP:Number = 1.0/20.0;
    private static const ORIG_WIDTH:int = 1200;
    
    [Bindable]
    public var gravity:Number = 9.8;
    
    private var _enableSimulation:Boolean = true;
    private var showDebug:Boolean = false;
    private var debugSprite:Sprite;
    private var firstTime:Boolean;
        
    
    /**
     * Constructor
     */
    public function BoxWorld() {}
    
    /**
     * @param the name of a class that implements Simulation
     */
    public function setSimulation(simulation:Simulation, 
                                  params:PhysicalParameters):void {
                                      
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        removeEventListener(ResizeEvent.RESIZE, resized);
        firstTime = true;
        world = createWorld();

        if (this.simulation != null) {
            this.simulation.cleanup();
        }
        simulation.initialize(world, this, params);
        this.simulation = simulation;
        startAnimation(); 
    }
    
    public function startAnimating():void {
    }

    public function startAnimation():void {
                          
        this.removeAllChildren();
        addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
        addEventListener(ResizeEvent.RESIZE, resized, false, 0, true);
                
        world.SetContinuousPhysics(true);
        
        simulation.addStaticElements(); 
        simulation.addDynamicElements();       
    }
    
    /** 
     * Needed prior to flex 4 
     * After Flex 4, we can use removeChildren method.
     */ 
    private function removeAllChildren():void {  
        for (var i:int = numChildren-1; i>=0; i--) {
            this.removeChildAt(i);
        }
    } 
    
    private function resized(evt:ResizeEvent):void {
        //simulation.scale = this.width / 100;
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
    
    public function onEnterFrame(e:Event):void{
          
        if (firstTime && enableSimulation && this.stage != null) {
            trace("adding interactors");
            simulation.createInteractors(); 
            firstTime = false;
        }
        // for stuff in the simulation that needs to be updated every frame
        simulation.onFrameUpdate(); 
        
        world.Step(TIME_STEP, VELOCITY_ITERATIONS, STEP_ITERATIONS); 
        world.ClearForces();
        if (showDebug) {
            world.DrawDebugData();
        }
        
        drawAllBodies();
        drawAllJoints(); 
    }
    
    /** Go through body list and update sprite positions/rotations */
    private function drawAllBodies():void {
        
        for (var bb:b2Body = world.GetBodyList(); bb; bb = bb.GetNext()) {
           
            //for (var fixture:b2Fixture = bb.GetFixtureList(); fixture; fixture = fixture.GetNext()) {
                var shape:AbstractShape = AbstractShape(bb.GetUserData()); 
                if (shape) {
                    shape.x = bb.GetPosition().x * simulation.scale;
                    shape.y = bb.GetPosition().y * simulation.scale;
                    shape.rotation = bb.GetAngle() * Util.RAD_TO_DEG;
                }
            //}
        } 
    }
    
    /** Go through joint list and render corresponding geometry */
    private function drawAllJoints():void {
        
        for (var joint:b2Joint = world.GetJointList(); joint; joint = joint.GetNext()) {
            
            if (joint.GetUserData()) {
                if (joint.GetUserData().GetUserData() is Line) {
                    var line:Line = Line(joint.GetUserData().GetUserData());
                 
                    line.x = joint.GetAnchorA().x * simulation.scale;
                    line.y = joint.GetAnchorA().y * simulation.scale;
                    
                    var numer:Number = joint.GetAnchorB().y - joint.GetAnchorA().y;
                    var denom:Number = joint.GetAnchorB().x - joint.GetAnchorA().x;
                    var angle:Number = Math.atan2(numer, denom);
                    
                    line.rotation = angle * Util.RAD_TO_DEG; 
                } 
                else if (joint.GetUserData().GetUserData() is AbstractShape) {
                    var shape:AbstractShape = AbstractShape(joint.GetUserData().GetUserData()); 
                   
                    shape.x = joint.GetAnchorA().x * simulation.scale;
                    shape.y = joint.GetAnchorA().y * simulation.scale;
                    shape.rotation = 0;
                }
            }
        }
    }
   
    private function createWorld():b2World {
        
        var gravityVec:b2Vec2 = new b2Vec2(0.0, gravity);
        var doSleep:Boolean = true;
        return new b2World(gravityVec, doSleep);
    }
      
    public function set showDebugDrawing(show:Boolean):void {
        if (show) {
            addDebugDrawing();
        }
        else {
            removeDebugDrawing();
        }
    }
    
    private function addDebugDrawing():void {
        // if already showing debug, dont do it again.
        if (!showDebug) {
            var dbgDraw:b2DebugDraw = new b2DebugDraw();
            debugSprite = new Sprite();
            addChild(debugSprite);
            dbgDraw.SetSprite(debugSprite);
            dbgDraw.SetDrawScale(simulation.scale);
            dbgDraw.SetFillAlpha(0.4);
            dbgDraw.SetLineThickness(2.0);
            dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit || b2DebugDraw.e_pairBit);  //0xFFFFFFFF;
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