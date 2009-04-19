package com.becker.animation.box2d.simulations
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import com.becker.animation.box2d.Simulation;
	import com.becker.animation.sprites.Circle;
	import com.becker.animation.sprites.Rectangle;
	
	import mx.core.UIComponent;
	
	public class AbstractSimulation implements Simulation
	{		
		protected var world:b2World;
		protected var canvas:UIComponent;
		protected var density:Number;
		protected var friction:Number;
		protected var restitution:Number;
		
		
		public function AbstractSimulation(world:b2World, canvas:UIComponent,
		                    density:Number = 1.0, friction:Number = 0.5, restitution:Number = 0.2)
		{
			this.world = world;	
			this.canvas = canvas;
			this.density = density;
			this.friction= friction;
			this.restitution = restitution;
		}
		
		public function addStaticElements():void {			
		}
        
        public function addDynamicElements():void {       	
        }
        
        public function get scale():Number {
        	return 20;
        }
	}
}