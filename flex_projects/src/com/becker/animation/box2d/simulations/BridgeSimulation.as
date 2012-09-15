package com.becker.animation.box2d.simulations {
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    import com.becker.common.PhysicalParameters;
    
    import com.becker.animation.box2d.builders.AbstractBuilder;
    import com.becker.animation.box2d.builders.BasicShapeBuilder;
    
    import flash.geom.Point;
    
    import mx.core.UIComponent;
    
    public class BridgeSimulation extends AbstractSimulation {
        private static const NUM_SHAPES:Number = 50;
        private static const NUM_PLANKS:int = 10;
        
        private var builder:BasicShapeBuilder;
        
        private var ground:b2Body;
        private var anchor:b2Vec2;   
        
        
        override public function initialize(world:b2World, canvas:UIComponent,
                            params:PhysicalParameters):void {
            super.initialize(world, canvas, params);
            builder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        override public function addStaticElements():void {
            
            ground = world.GetGroundBody();
            anchor = new b2Vec2();   
        }
        
    
        override public function addDynamicElements():void {
            
            addBridge();
            createBridgeCrap();
        }
        
        
        /**
         * Bridge
         */
        private function addBridge():void {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            var body:b2Body;
            //var body:b2Body = builder.buildBlock(24/scale, 5/scale, bodyDef, 20.0, 0.2, 0.1);  
            
            var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
            jd.lowerAngle = AbstractBuilder.degreesToRadians(-15); 
            jd.upperAngle = AbstractBuilder.degreesToRadians(15);
            jd.enableLimit = true;
            
            var prevBody:b2Body = ground;
            
            for (var i:int = 0; i < NUM_PLANKS; ++i) {
                bodyDef.position.Set((100 + 22 + 44 * i) / scale, 250 / scale);
                body = builder.buildBlock(24/scale, 5/scale, bodyDef, 20.0, 0.2, 0.1);  
                
                anchor.Set((100 + 44 * i) / scale, 250 / scale);
                jd.Initialize(prevBody, body, anchor);
                world.CreateJoint(jd);
                
                prevBody = body;
            }
            
            anchor.Set((100 + 44 * NUM_PLANKS) / scale, 250 / scale);
            jd.Initialize(prevBody, ground, anchor);
            world.CreateJoint(jd);
        }
        
        /**
         * Spawn in a bunch of crap to fall on the bridge.
         */
        private function createBridgeCrap():void {

            addBlocks(6);
            addBalls(5);
            createPolygons(15);
        }       
        
        private function addBlocks(num:int):void  {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            for (var i:int = 0; i < num; i++){
                
                bodyDef.position.Set((Math.random() * 400 + 120) / scale, (Math.random() * 150 + 50) / scale);
                bodyDef.angle = Math.random() * Math.PI;
                builder.buildBlock((Math.random() * 5 + 10) / scale, (Math.random() * 5 + 10) / scale, bodyDef, 1.0, 0.3, 0.1);  
            }
        }
        
        private function addBalls(num:int):void  {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            for (var i:int = 0; i < num; i++) {
                bodyDef.position.Set((Math.random() * 400 + 120) / scale, (Math.random() * 150 + 50) / scale);
                bodyDef.angle = Math.random() * Math.PI;           
                builder.buildBall((Math.random() * 5 + 10) / scale, bodyDef, 1.0, 0.3, 0.1);  
            }
        }
        
        private function createPolygons(num:int):void {
            
            var bodyDef:b2BodyDef = new b2BodyDef();
            for (var i:int = 0; i < num; i++){
                createRandomPolygon(bodyDef);
            }
        }
        
        private function createRandomPolygon(bodyDef:b2BodyDef):void {
            
            bodyDef.position.Set((Math.random() * 400 + 120) / scale, (Math.random() * 150 + 50) / scale);
            bodyDef.angle = Math.random() * Math.PI;
            var pts:Array;
            
            if (Math.random() > 0.66) {
                pts = createQuadrilateralPoints()
            }
            else if (Math.random() > 0.5) { 
                pts = createPentagonPoints();
            }
            else {
                pts = createTrianglePoints();
            }
    
            builder.buildPolygon(pts, bodyDef, 1.0, 0.3, 0.1);
        }
        
        private function createQuadrilateralPoints():Array {
            var pts:Array = new Array();
            pts.push(new Point((-10 - Math.random()*10) / scale, ( 10 + Math.random()*10) / scale));
            pts.push(new Point(( -5 - Math.random()*10) / scale, (-10 - Math.random()*10) / scale));
            pts.push(new Point((  5 + Math.random()*10) / scale, (-10 - Math.random()*10) / scale));
            pts.push(new Point(( 10 + Math.random() * 10) / scale, ( 10 + Math.random() * 10) / scale));
            return pts;
        }
        
        private function createPentagonPoints():Array {
            var pt0:Point = new Point(0, (10 +Math.random()*10) / scale);
            var pt2:Point = new Point((-5 - Math.random()*10) / scale, (-10 -Math.random()*10) / scale);
            var pt3:Point = new Point(( 5 + Math.random()*10) / scale, (-10 -Math.random()*10) / scale);
            var s:Number = Math.random()/2 + 0.8;
            var pt1:Point = new Point(s*(pt0.x + pt2.x), s*(pt0.y + pt2.y));
            s = Math.random()/2 + 0.8;
            var pt4:Point = new Point(s*(pt3.x + pt0.x), s*(pt3.y + pt0.y));
            return [pt0, pt1, pt2, pt3, pt4]; 
        }
        
        private function createTrianglePoints():Array {
            var pts:Array = new Array();
            pts.push(new Point(0, (10 +Math.random()*10) / scale));
            pts.push(new Point((-5 - Math.random()*10) / scale, (-10 -Math.random()*10) / scale));
            pts.push(new Point(( 5 + Math.random() * 10) / scale, ( -10 -Math.random() * 10) / scale));
            return pts;
        }
        
    }
}