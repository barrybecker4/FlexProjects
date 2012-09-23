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
    
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.common.PhysicalParameters;
    
    import com.becker.animation.box2d.builders.AbstractBuilder;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    
    import mx.core.UIComponent;
    
    public class HelloWorldSimulation extends AbstractSimulation {
        
        private static const NUM_SHAPES:Number = 50;
        
        private var builder:BasicShapeBuilder;
        
        private var staticCircle:b2Body;
        
        override public function initialize(world:b2World, canvas:UIComponent,
                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        override public function addStaticElements():void {
                        
            var bodyDef:b2BodyDef = new b2BodyDef();   
            bodyDef.type = b2Body.b2_staticBody;
            bodyDef.position.Set(28, 23);
            // a pivot point for the see-saw plank
            staticCircle = builder.buildBall(1, bodyDef, 0, params.friction, params.restitution);
        }
        
        override public function addDynamicElements():void {
            
            // add a big see-saw attached to the static circle for the shapes to land on.
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            bodyDef.position.Set(28, 20);
            bodyDef.angle = -0.1;
            var groundBlock:b2Body = builder.buildBlock(24, 2, bodyDef, params.density, params.friction, params.restitution);
            
            var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
            jd.enableLimit = true;
            
            // static point to seesaw plank
            jd.lowerAngle = AbstractBuilder.degreesToRadians(-1);
            jd.upperAngle = AbstractBuilder.degreesToRadians(1);
            //jd.enableMotor = true;
            //jd.maxMotorTorque = 100;
            jd.Initialize(staticCircle, groundBlock, staticCircle.GetWorldCenter());
            world.CreateJoint(jd);
            
            
            // Add some objects
            for (var i:int = 1; i < NUM_SHAPES; i++){
                bodyDef.position.Set(Math.random() * 15 + 20, Math.random() * 10);

                var rX:Number = Math.random() + 0.5;
                var rY:Number = Math.random() + 0.5;
          
                if (Math.random() < 0.5) {
                    builder.buildBlock(rX, rY, bodyDef, params.density, params.friction, params.restitution);
                } 
                else {
                    builder.buildBall(rX, bodyDef, params.density, params.friction, params.restitution);
                }  
            }
        }
    }
}