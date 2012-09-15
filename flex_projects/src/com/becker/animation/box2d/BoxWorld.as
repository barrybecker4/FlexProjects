package  com.becker.animation.box2d {
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;
import Box2D.Dynamics.Joints.b2Joint;
import com.becker.animation.sprites.Line;
import com.becker.common.PhysicalParameters;
import flash.geom.Point;

import com.becker.animation.Animatible;
import com.becker.animation.box2d.simulations.BridgeSimulation;
import com.becker.animation.box2d.simulations.HelloWorldSimulation;
import com.becker.animation.box2d.simulations.RagDollSimulation;
import com.becker.animation.box2d.simulations.TheoJansenSimulation;
import com.becker.animation.sprites.AbstractShape;

import flash.display.Sprite;
import flash.events.Event;

import mx.core.UIComponent;
import mx.events.ResizeEvent;

/**
 * The simulated world of shapes interacting with the users mouse and the environment.
 * 
 * ideas todo:
 *  - simplify simple shape construction to include position.
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
    
    private var _enableSimulation:Boolean = true;
    
    private var showDebug:Boolean = false;
    private var debugSprite:Sprite;
   
    private var mouseInteractor:MouseInteractor;
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
        firstTime = true;
        world = createWorld();
        simulation.initialize(world, this, params);
        this.simulation = simulation;
        startAnimation(); 
    }
    
    public function startAnimating():void {
        if (world == null) {
            //setSimulation(AVAILABLE_SIMULATIONS[0]);
        }
    }
    
    public function startAnimation():void {
                          
        this.removeAllChildren();
        addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
        addEventListener(ResizeEvent.RESIZE, resized, false, 0, true);
               
        world.SetContactListener(new ContactListener());    
        if (showDebug) {    
            addDebugDrawing();
        }
        
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
    
    public function onEnterFrame(e:Event):void{
          
       if (firstTime && enableSimulation && this.stage != null) {
            mouseInteractor = new MouseInteractor(this, world); 
            firstTime = false;
        }
        
        world.Step(TIME_STEP, NUM_ITERATIONS);
        
        // Go through body list and update sprite positions/rotations
        
        for (var bb:b2Body = world.m_bodyList; bb; bb = bb.m_next) {
            
            if (bb.m_userData is AbstractShape) {
                bb.m_userData.x = bb.GetPosition().x * simulation.scale;
                bb.m_userData.y = bb.GetPosition().y * simulation.scale;
                bb.m_userData.rotation = bb.GetAngle() * (180 / Math.PI);
            }
        } 

        for (var joint:b2Joint = world.m_jointList; joint; joint = joint.m_next) {
            
            if (joint.m_userData && joint.m_userData.m_userData is Line) {
                var line:Line = joint.m_userData.m_userData as Line;
                if (line) {
                    //line.x = joint.GetBody1().GetPosition().x * simulation.scale;
                    //line.y = joint.GetBody1().GetPosition().y * simulation.scale;
                    //line.rotation = joint.GetBody1().GetAngle() * (180 / Math.PI);
                    
                    var startPt:Point = new Point(joint.GetAnchor1().x * simulation.scale, joint.GetAnchor1().y * simulation.scale);;
                    var endPt:Point = new Point(joint.GetAnchor2().x * simulation.scale, joint.GetAnchor2().y * simulation.scale);
                    line.x = startPt.x;
                    line.y = startPt.y;
                    line.width = endPt.x - startPt.x;
                    line.height = endPt.y - startPt.y;
                }
            }
        }
        
        mouseInteractor.handleMouseInteraction(TIME_STEP, simulation.scale); 
    }
    
    /*
    public function DrawJoint(joint:b2Joint):void {
        
        var b1:b2Body = joint.m_body1;
        var b2:b2Body = joint.m_body2;
        var xf1:b2XForm = b1.m_xf;
        var xf2:b2XForm = b2.m_xf;
        var x1:b2Vec2 = xf1.position;
        var x2:b2Vec2 = xf2.position;
        var p1:b2Vec2 = joint.GetAnchor1();
        var p2:b2Vec2 = joint.GetAnchor2();
        
        //b2Color color(0.5f, 0.8f, 0.8f);
        var color:b2Color = s_jointColor;
        
        switch (joint.m_type) {
            case b2Joint.e_distanceJoint:
                m_debugDraw.DrawSegment(p1, p2, color);
                break;
            
            case b2Joint.e_pulleyJoint:
                var pulley:b2PulleyJoint = (joint as b2PulleyJoint);
                var s1:b2Vec2 = pulley.GetGroundAnchor1();
                var s2:b2Vec2 = pulley.GetGroundAnchor2();
                m_debugDraw.DrawSegment(s1, p1, color);
                m_debugDraw.DrawSegment(s2, p2, color);
                m_debugDraw.DrawSegment(s1, s2, color);
                break;
            
            case b2Joint.e_mouseJoint:
                m_debugDraw.DrawSegment(p1, p2, color);
                break;
            
            default:
                if (b1 != m_groundBody)
                    m_debugDraw.DrawSegment(x1, p1, color);
                m_debugDraw.DrawSegment(p1, p2, color);
                if (b2 != m_groundBody)
                    m_debugDraw.DrawSegment(x2, p2, color);
        }
    } */
   
    private function createWorld():b2World {
        // Create world AABB
        var worldAABB:b2AABB = new b2AABB();
        worldAABB.lowerBound.Set(-100.0, -100.0);
        worldAABB.upperBound.Set(100.0, 100.0);
        
        var gravityVec:b2Vec2 = new b2Vec2(0.0, gravity);
        var doSleep:Boolean = true;
        return new b2World(worldAABB, gravityVec, doSleep);
    }
      
    public function set showVectors(show:Boolean):void {
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
            dbgDraw.m_sprite = debugSprite;
            dbgDraw.m_drawScale = simulation.scale;
            dbgDraw.m_fillAlpha = 0.4;
            dbgDraw.m_lineThickness = 2.0;
            dbgDraw.m_drawFlags = b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit; //0xFFFFFFFF;
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