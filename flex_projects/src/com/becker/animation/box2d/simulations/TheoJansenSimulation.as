package com.becker.animation.box2d.simulations {
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2DistanceJointDef;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.common.PhysicalParameters;
    
    import com.becker.animation.box2d.builders.AbstractBuilder;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    
    import mx.core.UIComponent;
    
    public class TheoJansenSimulation extends AbstractSimulation {
        private static const T_SCALE:Number = 4.0;
        
        
        private var builder:BasicShapeBuilder;
        
        private var staticCircle:b2Body;
        
        private var chassis:b2Body;
        private var wheel:b2Body;
            
        
        override public function initialize(world:b2World, canvas:UIComponent,
                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        override public function addStaticElements():void {
            
            // Add ground body
            var bodyDef:b2BodyDef = new b2BodyDef();
            // bodyDef.position.Set(20, 20);
            // bodyDef.angle = 0.1;
            // var groundBlock:b2Body = builder.buildBlock(20, 2, bodyDef, 0, friction, restitution);
            
            bodyDef.position.Set(20, 46);
            staticCircle = builder.buildBlock(100, 4, bodyDef, 0, params.friction, params.restitution);
        }
        
        override public function addDynamicElements():void {
            var bodyDef:b2BodyDef = new b2BodyDef();
            
            
            for (var j:int = 0; j < 40; ++j)
            {
                bodyDef.position.Set(Math.random() * 62 + 1, Math.random());
                builder.buildBall(0.35, bodyDef, 1.0, params.friction, params.restitution);
            }
                       
            // Add some objects
            for (var i:int = 1; i < 6; i++){
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
            
            var offset:b2Vec2 = new b2Vec2();
            var motorJoint:b2RevoluteJoint;
            var motorOn:Boolean = true;
            var motorSpeed:Number = -2;
            
            var pd:b2PolygonDef;
            var cd:b2CircleDef;
            var body:b2Body;
            var tscale:Number = T_SCALE;
                       
            // Set position in world space
            offset.Set(35.0, 25);
            var pivot:b2Vec2 = new b2Vec2(0.0, -24.0/tscale);
            
            bodyDef.position = b2Math.AddVV(pivot, offset);
            chassis = builder.buildBlock(7.5/tscale, 3.0/tscale, bodyDef, 1.0, params.friction, params.restitution, -1);
              
            bodyDef.position = b2Math.AddVV(pivot, offset);
            wheel = builder.buildBall(4.8/tscale, bodyDef, 1.0, params.friction, params.restitution, -1);
        
            var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
            var po:b2Vec2 = pivot.Copy();
            po.Add(offset);
            jd.Initialize(wheel, chassis, po);
            jd.collideConnected = false;
            jd.motorSpeed = motorSpeed;
            jd.maxMotorTorque = 400.0;
            jd.enableMotor = motorOn;
            motorJoint = world.CreateJoint(jd) as b2RevoluteJoint;            
            
            var wheelAnchor:b2Vec2;
            
            wheelAnchor = new b2Vec2(0.0, 24/tscale);
            wheelAnchor.Add(pivot);
            
            CreateLeg(-1.0, wheelAnchor, offset);
            CreateLeg(1.0, wheelAnchor, offset);
            
            wheel.SetXForm(wheel.GetPosition(), AbstractBuilder.degreesToRadians(120.0));
            CreateLeg(-1.0, wheelAnchor, offset);
            CreateLeg(1.0, wheelAnchor, offset);
            
            wheel.SetXForm(wheel.GetPosition(), AbstractBuilder.degreesToRadians(-120.0));
            CreateLeg(-1.0, wheelAnchor, offset);
            CreateLeg(1.0, wheelAnchor, offset);
        }
               
        
        private function CreateLeg(s:Number, wheelAnchor:b2Vec2, offset:b2Vec2):void {
            
            var tScale:Number = T_SCALE;
            var p1:b2Vec2 = new b2Vec2(16.2 * s/tScale, 18.3/tScale);
            var p2:b2Vec2 = new b2Vec2(21.6 * s/tScale, 3.6 /tScale);
            var p3:b2Vec2 = new b2Vec2(12.9 * s/tScale, 5.7 /tScale);
            var p4:b2Vec2 = new b2Vec2( 9.3 * s/tScale, -2.4 /tScale);
            var p5:b2Vec2 = new b2Vec2(18.0 * s/tScale, -4.5 /tScale);
            var p6:b2Vec2 = new b2Vec2( 7.5 * s/tScale, -11.1 /tScale);

            
            var sd1Pts:Array = new Array();
            var sd2Pts:Array = new Array();
      
            if (s > 0.0)
            {
                sd1Pts.push(p3);
                sd1Pts.push(p2);
                sd1Pts.push(p1);
                
                sd2Pts.push(b2Math.SubtractVV(p6, p4));
                sd2Pts.push(b2Math.SubtractVV(p5, p4));
                sd2Pts.push(new b2Vec2());
            }
            else
            {
                sd1Pts.push(p2);
                sd1Pts.push(p3);
                sd1Pts.push(p1);
                
                sd2Pts.push(b2Math.SubtractVV(p5, p4));
                sd2Pts.push(b2Math.SubtractVV(p6, p4));
                sd2Pts.push(new b2Vec2());
            }

            var bodyDef:b2BodyDef = new b2BodyDef(); 
            bodyDef.angularDamping = 10.0;
            bodyDef.position.SetV(offset);
            var body1:b2Body = builder.buildPolygon(sd1Pts, bodyDef, params.density, params.friction, params.restitution, -1);
            
            bodyDef.position = b2Math.AddVV(p4, offset); 
            var body2:b2Body = builder.buildPolygon(sd2Pts, bodyDef, params.density, params.friction, params.restitution, -1);
            
            var djd:b2DistanceJointDef = new b2DistanceJointDef();
            
            djd.Initialize(body1, body2, b2Math.AddVV(p2, offset), b2Math.AddVV(p5, offset));
            world.CreateJoint(djd);
            
            djd.Initialize(body1, body2, b2Math.AddVV(p3, offset), b2Math.AddVV(p4, offset));
            world.CreateJoint(djd);
            
            djd.Initialize(body1, wheel, b2Math.AddVV(p3, offset), b2Math.AddVV(wheelAnchor, offset));
            world.CreateJoint(djd);
            
            djd.Initialize(body2, wheel, b2Math.AddVV(p6, offset), b2Math.AddVV(wheelAnchor, offset));
            world.CreateJoint(djd);
            
            var rjd:b2RevoluteJointDef = new b2RevoluteJointDef();
            
            rjd.Initialize(body2, chassis, b2Math.AddVV(p4, offset));
            world.CreateJoint(rjd);                        
        }
    }
}

