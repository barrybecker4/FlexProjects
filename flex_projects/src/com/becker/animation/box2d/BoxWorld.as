package  com.becker.animation.box2d {
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;

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
                                  density:Number, friction:Number, restitution:Number):void {
        firstTime = true;
        world = createWorld();
        simulation.initialize(world, this, density, friction, restitution);
        this.simulation = simulation;
        startAnimation();
    }
    
    public function startAnimating():void {
        if (world == null) {
            //setSimulation(AVAILABLE_SIMULATIONS[0]);
        }
    }
    
    public function startAnimation():void {
                          
        this.removeChildren();
        addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
        addEventListener(ResizeEvent.RESIZE, resized, false, 0, true);
               
        world.SetContactListener(new ContactListener());    
        if (showDebug) {    
            addDebugDrawing();
        }
        
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
    
    public function onEnterFrame(e:Event):void{
          
       if (firstTime && enableSimulation && this.stage != null) {
            mouseInteractor = new MouseInteractor(this, world); 
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
        
        mouseInteractor.handleMouseInteraction(TIME_STEP, simulation.scale); 
    }
   
    private function createWorld():b2World {
        // Create world AABB
        var worldAABB:b2AABB = new b2AABB();
        worldAABB.lowerBound.Set(-100.0, -100.0);
        worldAABB.upperBound.Set(100.0, 100.0);
        
        var gravityVec:b2Vec2 = new b2Vec2(0.0, gravity);
        var doSleep:Boolean = true;
        return new b2World(worldAABB, gravityVec, doSleep);
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