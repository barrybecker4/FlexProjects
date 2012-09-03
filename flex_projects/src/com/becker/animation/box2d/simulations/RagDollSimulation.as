/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/
package com.becker.animation.box2d.simulations {
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    
    import com.becker.animation.box2d.builders.RagDollBuilder;
    import com.becker.animation.sprites.Rectangle;
    
    import mx.core.UIComponent;
    
    public class RagDollSimulation extends AbstractSimulation {
        private static const NUM_DOLLS:Number = 10;
        
        private var ragDollBuilder:RagDollBuilder;
        
        public function RagDollSimulation(world:b2World, canvas:UIComponent,
                                     density:Number, friction:Number, restitution:Number) {
            super(world, canvas, density, friction, restitution);
            ragDollBuilder = new RagDollBuilder(world, canvas, scale);            
        }
        
        override public function addStaticElements():void {
            // Add ground body
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.position.Set(20, 20);
            bodyDef.angle = 0.1;
            var boxDef:b2PolygonDef = new b2PolygonDef();
            boxDef.SetAsBox(20, 2);
            boxDef.friction = friction;
            boxDef.density = 0; // static bodies require zero density
            
            // Add sprite to body userData. The ground.
            bodyDef.userData = new Rectangle(scale * 2 * 20, scale * 2 * 2); 
            
            var body:b2Body = world.CreateBody(bodyDef);
            body.CreateShape(boxDef);
            canvas.addChild(bodyDef.userData);
                       
              
            body.SetMassFromShapes();
        }
        
        override public function addDynamicElements():void {
            
            // Add some objects
            for (var i:int = 0; i < NUM_DOLLS; i++){
                var startX:Number = 70 + Math.random() * 20 + 70 * i;
                var startY:Number = 20 + Math.random() * 50;
                ragDollBuilder.buildInstance(startX, startY, density, friction, restitution);
            }
        }
    }
}