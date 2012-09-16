package com.becker.animation.box2d.builders {
    
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Common.Math.b2Math;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import Box2D.Dynamics.Joints.b2DistanceJointDef;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import com.becker.animation.sprites.Line;
    import com.becker.common.PhysicalParameters;
    import flash.geom.Point;
    import mx.core.UIComponent;
    
    
    public class TheoJansenSpiderBuilder extends AbstractBuilder {
        
        private static const T_SCALE:Number = 4.0;
        private static const MOTOR_SPEED:Number = -2.0;
        private static const MOTOR_TORQUE:Number = 400.0;
        
        private static const WHEEL_RADIUS:Number = 4.8;
        private static const CHASSIS_WIDTH:Number = 7.5;
        private static const CHASSIS_HEIGHT:Number = 3.0;
        
        private var shapeBuilder:BasicShapeBuilder;
        private var params:PhysicalParameters;
        private var offset:b2Vec2;
        
    
        /** Constructor */
        public function TheoJansenSpiderBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
            shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        
        public function buildInstance(startX:Number, startY:Number, 
                                      params:PhysicalParameters):TheoJansenSpider {           

            var bodyDef:b2BodyDef = new b2BodyDef();
            this.offset = new b2Vec2();
            this.params = params;
            
            // Set position in world space
            offset.Set(startX, startY);
            //trace("initial position " + startX + " " + startY);
            
            var pivot:b2Vec2 = new b2Vec2(0.0, -WHEEL_RADIUS/T_SCALE);
            bodyDef.position = b2Math.AddVV(pivot, offset);
            var chassis:b2Body = 
                shapeBuilder.buildBlock(CHASSIS_WIDTH / T_SCALE, CHASSIS_HEIGHT / T_SCALE, 
                                       bodyDef, 1.0, params.friction, params.restitution, -1);
              
            bodyDef.position = b2Math.AddVV(pivot, offset);
            var wheel:b2Body = 
                shapeBuilder.buildBall(WHEEL_RADIUS / T_SCALE, bodyDef, 1.0, params.friction, params.restitution, -1);
            
            var wheelAnchor:b2Vec2 = new b2Vec2(0.0, 0.5 * WHEEL_RADIUS / T_SCALE);
            
            var spider:TheoJansenSpider = new TheoJansenSpider(chassis, wheel, wheelAnchor);
        
            createMotorJoint(spider, pivot);
            wheelAnchor.Add(pivot);
            
            createLegs(spider);

            return spider;   
        }
        
        private function createLegs(spider:TheoJansenSpider):void {
            CreateLeg(spider, -1.0);
            CreateLeg(spider, 1.0);
            
            spider.wheel.SetXForm(spider.wheel.GetPosition(), AbstractBuilder.degreesToRadians(120.0));
            CreateLeg(spider, -1.0);
            CreateLeg(spider, 1.0);
            
            spider.wheel.SetXForm(spider.wheel.GetPosition(), AbstractBuilder.degreesToRadians(-120.0));
            CreateLeg(spider, -1.0);
            CreateLeg(spider, 1.0);
        }
        
        
        private function createMotorJoint(spider:TheoJansenSpider, pivot:b2Vec2):void { 
            var motorJoint:b2RevoluteJoint;
            
            var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
            var po:b2Vec2 = pivot.Copy();
            po.Add(offset);
            jd.Initialize(spider.wheel, spider.chassis, po);
            jd.collideConnected = false;
            jd.motorSpeed = MOTOR_SPEED;
            jd.maxMotorTorque = MOTOR_TORQUE;
            jd.enableMotor = true;
            motorJoint = world.CreateJoint(jd) as b2RevoluteJoint;            
        }
        
        private function CreateLeg(spider:TheoJansenSpider, sign:Number):void {
            
            var points:Array = createLegPoints(sign, T_SCALE);
            
            var sd1Pts:Array = new Array();
            var sd2Pts:Array = new Array();
      
            if (sign > 0.0)  {
                sd1Pts.push(points[2]);
                sd1Pts.push(points[1]);
                sd1Pts.push(points[0]);
                
                sd2Pts.push(b2Math.SubtractVV(points[5], points[3]));
                sd2Pts.push(b2Math.SubtractVV(points[4], points[3]));
                sd2Pts.push(new b2Vec2());
            }
            else {
                sd1Pts.push(points[1]);
                sd1Pts.push(points[2]);
                sd1Pts.push(points[0]);
                
                sd2Pts.push(b2Math.SubtractVV(points[4], points[3]));
                sd2Pts.push(b2Math.SubtractVV(points[5], points[3]));
                sd2Pts.push(new b2Vec2());
            }

            var bodyDef:b2BodyDef = new b2BodyDef(); 
            
            bodyDef.position.SetV(offset);
            bodyDef.angularDamping = 10.0;
            
            var segment1:b2Body = 
                shapeBuilder.buildPolygon(sd1Pts, bodyDef, params.density, params.friction, params.restitution, -1);
                
            bodyDef.position = b2Math.AddVV(points[3], offset);
            var segment2:b2Body =
                shapeBuilder.buildPolygon(sd2Pts, bodyDef, params.density, params.friction, params.restitution, -1);
            
            createLegJoints(spider, segment1, segment2, points);
        }
        
        private function createLegPoints(sign:Number, tScale:Number):Array {
            var points:Array = [];
            points.push(new b2Vec2(16.2 * sign/tScale, 18.3/tScale));
            points.push(new b2Vec2(21.6 * sign/tScale, 3.6 /tScale));
            points.push(new b2Vec2(12.9 * sign/tScale, 5.7 /tScale));
            points.push(new b2Vec2( 9.3 * sign/tScale, -2.4 /tScale));
            points.push(new b2Vec2(18.0 * sign/tScale, -4.5 /tScale));
            points.push(new b2Vec2( 7.5 * sign/tScale, -11.1 /tScale));
            return points;
        }
        
        private function createLegJoints(spider:TheoJansenSpider, segment1:b2Body, segment2:b2Body, points:Array):void {
                                             
            var djd:b2DistanceJointDef = new b2DistanceJointDef();
            var bodyDef:b2BodyDef = new b2BodyDef();
            
            djd.userData = shapeBuilder.buildLine(points[1], points[4], bodyDef, params);
            djd.Initialize(segment1, segment2, b2Math.AddVV(points[1], offset), b2Math.AddVV(points[4], offset));
            world.CreateJoint(djd);
            
            djd.userData = shapeBuilder.buildLine(points[2], points[3], bodyDef, params);
            djd.Initialize(segment1, segment2, b2Math.AddVV(points[2], offset), b2Math.AddVV(points[3], offset));
            world.CreateJoint(djd);
            
            djd.userData = shapeBuilder.buildLine(points[2], spider.wheelAnchor, bodyDef, params);
            djd.Initialize(segment1, spider.wheel, b2Math.AddVV(points[2], offset), b2Math.AddVV(spider.wheelAnchor, offset));
            world.CreateJoint(djd);
                    
            djd.userData = shapeBuilder.buildLine(points[5], spider.wheelAnchor, bodyDef, params);
            djd.Initialize(segment2, spider.wheel, b2Math.AddVV(points[5], offset), b2Math.AddVV(spider.wheelAnchor, offset));
            world.CreateJoint(djd);
            
            var rjd:b2RevoluteJointDef = new b2RevoluteJointDef();
            
            // don't show this because chassis and points[3] are on top of each other 
            //trace("pider.chassis.GetLocalCenter()=" + spider.chassis.GetLocalCenter() + " points[3]=" + points[3]);
            //rjd.userData = shapeBuilder.buildLine(spider.chassis.GetLocalCenter(), points[3], bodyDef, params);
            rjd.Initialize(segment2, spider.chassis, b2Math.AddVV(points[3], offset));
            world.CreateJoint(rjd);   
        }

        private function vec2Point(pt:b2Vec2):Point {
            return new Point(scale * pt.x, scale * pt.y);
        }
    }
}