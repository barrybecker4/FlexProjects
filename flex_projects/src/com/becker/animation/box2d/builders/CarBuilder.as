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
    
    
    public class CarBuilder extends AbstractBuilder {
        
        private static const T_SCALE:Number = 4.0;
        private static const MOTOR_SPEED:Number = -2.0;
        private static const MOTOR_TORQUE:Number = 400.0;
        
        private var shapeBuilder:BasicShapeBuilder;
        private var params:PhysicalParameters;
        
    
        /** Constructor */
        public function CarBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
            shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        
        public function buildInstance(startX:Number, startY:Number, 
                                      params:PhysicalParameters):Car {           

            var bodyDef:b2BodyDef = new b2BodyDef();
            var offset:b2Vec2 = new b2Vec2();
            this.params = params;
            
            // Set position in world space
            offset.Set(startX, startY);
            
            var pivot:b2Vec2 = new b2Vec2(0.0, -2.4/T_SCALE);
            bodyDef.position = b2Math.AddVV(pivot, offset);
            var chassis:b2Body = shapeBuilder.buildBlock(7.5/T_SCALE, 3.0/T_SCALE, bodyDef, 1.0, params.friction, params.restitution, -1);
              
            bodyDef.position = b2Math.AddVV(pivot, offset);
            var wheel:b2Body = shapeBuilder.buildBall(4.8 / T_SCALE, bodyDef, 1.0, params.friction, params.restitution, -1);
            
            var wheelAnchor:b2Vec2 = new b2Vec2(0.0, 2.4 / T_SCALE);
            
            var car:Car = new Car(chassis, wheel, wheelAnchor);
        
            createMotorJoint(car, pivot, offset);
            wheelAnchor.Add(pivot);
            
            CreateLeg(car, -1.0, offset);
            CreateLeg(car, 1.0, offset);
            
            wheel.SetXForm(wheel.GetPosition(), AbstractBuilder.degreesToRadians(120.0));
            CreateLeg(car, -1.0, offset);
            CreateLeg(car, 1.0, offset);
            
            wheel.SetXForm(wheel.GetPosition(), AbstractBuilder.degreesToRadians(-120.0));
            CreateLeg(car, -1.0, offset);
            CreateLeg(car, 1.0, offset);
            
            return car;   
        }
        
        private function createMotorJoint(car:Car, pivot:b2Vec2, offset:b2Vec2):void { //b2RevoluteJoint 
            var motorJoint:b2RevoluteJoint;
            
            var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
            var po:b2Vec2 = pivot.Copy();
            po.Add(offset);
            jd.Initialize(car.wheel, car.chassis, po);
            jd.collideConnected = false;
            jd.motorSpeed = MOTOR_SPEED;
            jd.maxMotorTorque = MOTOR_TORQUE;
            jd.enableMotor = true;
            motorJoint = world.CreateJoint(jd) as b2RevoluteJoint;            
        }
        
        private function CreateLeg(spider:Car, 
                       sign:Number, offset:b2Vec2):void {
            
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
            
            var segment1:b2Body = shapeBuilder.buildPolygon(sd1Pts, bodyDef, params.density, params.friction, params.restitution, -1);
            bodyDef.position = b2Math.AddVV(points[3], offset);
            var segment2:b2Body = shapeBuilder.buildPolygon(sd2Pts, bodyDef, params.density, params.friction, params.restitution, -1);
            
            createLegJoints(spider, segment1, segment2, offset, points);
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
        
        private function createLegJoints(spider:Car, body1:b2Body, body2:b2Body, 
                                         offset:b2Vec2, points:Array):void {
            var djd:b2DistanceJointDef = new b2DistanceJointDef();
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            
            djd.userData = shapeBuilder.buildLine(b2Math.AddVV(points[1], offset), b2Math.AddVV(points[4], offset), bodyDef, params);
            djd.Initialize(body1, body2, b2Math.AddVV(points[1], offset), b2Math.AddVV(points[4], offset));
            world.CreateJoint(djd);
            
            //djd.userData = shapeBuilder.buildLine(b2Math.AddVV(points[2], offset), b2Math.AddVV(points[3], offset), bodyDef, params);
            djd.Initialize(body1, body2, b2Math.AddVV(points[2], offset), b2Math.AddVV(points[3], offset));
            world.CreateJoint(djd);
            
            //djd.userData = shapeBuilder.buildLine(b2Math.AddVV(points[2], offset), b2Math.AddVV(spider.wheelAnchor, offset), bodyDef, params);
            djd.Initialize(body1, spider.wheel, b2Math.AddVV(points[2], offset), b2Math.AddVV(spider.wheelAnchor, offset));
            world.CreateJoint(djd);
            
            //djd.userData = shapeBuilder.buildLine(b2Math.AddVV(points[5], offset), b2Math.AddVV(spider.wheelAnchor, offset), bodyDef, params);
            djd.Initialize(body2, spider.wheel, b2Math.AddVV(points[5], offset), b2Math.AddVV(spider.wheelAnchor, offset));
            world.CreateJoint(djd);
            
            var rjd:b2RevoluteJointDef = new b2RevoluteJointDef();
            
            //djd.userData = shapeBuilder.buildLine(spider.chassis, b2Math.AddVV(points[3], offset), bodyDef, params);
            rjd.Initialize(body2, spider.chassis, b2Math.AddVV(points[3], offset));
            world.CreateJoint(rjd);   
        }

        private function vec2Point(pt:b2Vec2):Point {
            return new Point(scale * pt.x, scale * pt.y);
        }
    }
}