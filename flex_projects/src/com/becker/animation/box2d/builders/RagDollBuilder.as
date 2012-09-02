package com.becker.animation.box2d.builders {
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    
    import mx.core.UIComponent;
    
    public class RagDollBuilder extends AbstractBuilder {
        
        private var shapeBuilder:BasicShapeBuilder;
        private var ragDoll:RagDoll;
    
        
        public function RagDollBuilder(world:b2World, canvas:UIComponent, scale:Number) {
        	super(world, canvas, scale);
        	shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
        }
        
       
        public function buildInstance(startX:Number, startY:Number, 
                            density:Number=1.0, friction:Number = 0.5, restitution:Number = 0.2):RagDoll  {           
            var bodyDef:b2BodyDef;    
            var box:b2PolygonDef = new b2PolygonDef();      
            
            // Head
            bodyDef = new b2BodyDef();
            bodyDef.position.Set(startX / scale, startY / scale);
            var head:b2Body = shapeBuilder.buildBall(12.5 / scale, bodyDef, 1.0, 0.4, 0.3);
            head.ApplyImpulse(new b2Vec2(Math.random() * 10 - 5, Math.random() * 10 - 5), head.GetWorldCenter());
          
            // Torso1 
            bodyDef.position.Set(startX / scale, (startY + 28) / scale);               
            var torso1:b2Body = shapeBuilder.buildBlock(15 / scale, 10 / scale, bodyDef, 1.0, 0.4, 0.1);
            
            // Torso2
            bodyDef.position.Set(startX / scale, (startY + 43) / scale);
            var torso2:b2Body = shapeBuilder.buildBlock(15 / scale, 10 / scale, bodyDef, 1.0, 0.4, 0.1);
            
            // Torso3
            bodyDef.position.Set(startX / scale, (startY + 58) / scale);
            var torso3:b2Body = shapeBuilder.buildBlock(15 / scale, 10 / scale, bodyDef, 1.0, 0.4, 0.1);
            
            // UpperArm
            //L
            bodyDef.position.Set((startX - 30) / scale, (startY + 20) / scale);
            var upperArmL:b2Body = shapeBuilder.buildBlock(18 / scale, 6.5 / scale, bodyDef, 1.0, 0.4, 0.1);
            // R
            bodyDef.position.Set((startX + 30) / scale, (startY + 20) / scale);
            var upperArmR:b2Body = shapeBuilder.buildBlock(18 / scale, 6.5 / scale, bodyDef, 1.0, 0.4, 0.1);
            
            // LowerArm
            // L
            bodyDef.position.Set((startX - 57) / scale, (startY + 20) / scale);
            var lowerArmL:b2Body = shapeBuilder.buildBlock(17 / scale, 6 / scale, bodyDef, 1.0, 0.4, 0.1);
            // R
            bodyDef.position.Set((startX + 57) / scale, (startY + 20) / scale);
            var lowerArmR:b2Body = shapeBuilder.buildBlock(17 / scale, 6 / scale, bodyDef, 1.0, 0.4, 0.1);
            
            // UpperLeg
            // L
            bodyDef.position.Set((startX - 8) / scale, (startY + 85) / scale);
            var upperLegL:b2Body = shapeBuilder.buildBlock(7.5 / scale, 22 / scale, bodyDef, 1.0, 0.4, 0.1);
            // R
            bodyDef.position.Set((startX + 8) / scale, (startY + 85) / scale);
            var upperLegR:b2Body = shapeBuilder.buildBlock(7.5 / scale, 22 / scale, bodyDef, 1.0, 0.4, 0.1);
            
            // LowerLeg 
            // L
            bodyDef.position.Set((startX - 8) / scale, (startY + 120) / scale);
            var lowerLegL:b2Body = shapeBuilder.buildBlock(6 / scale, 20 / scale, bodyDef, 1.0, 0.4, 0.1);
            // R
            bodyDef.position.Set((startX + 8) / scale, (startY + 120) / scale);
            var lowerLegR:b2Body = shapeBuilder.buildBlock(6 / scale, 20 / scale, bodyDef, 1.0, 0.4, 0.1);
            
            
            ragDoll = new RagDoll(head, torso1, torso2, torso3, upperArmL, upperArmR, lowerArmL, lowerArmR, 
                                  upperLegL, upperLegR, lowerLegL, lowerLegR);
            
            createJoints(startX, startY, ragDoll);     
            return ragDoll;      
        }
        
        private function createJoints(startX:Number, startY:Number, ragDoll:RagDoll):void {
			
        	// JOINTS
            var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
            jd.enableLimit = true;
            
            // Head to shoulders
            jd.lowerAngle = degreesToRadians(-40);
            jd.upperAngle = degreesToRadians(40);
            jd.Initialize(ragDoll.torso1, ragDoll.head, new b2Vec2(startX / scale, (startY + 15) / scale));
            world.CreateJoint(jd);
            
            // Upper arm to shoulders
            // L
            jd.lowerAngle = degreesToRadians(-85);
            jd.upperAngle = degreesToRadians(130);
            jd.Initialize(ragDoll.torso1, ragDoll.upperArmL, new b2Vec2((startX - 18) / scale, (startY + 20) / scale));
            world.CreateJoint(jd);
            // R
            jd.lowerAngle = degreesToRadians(-130);
            jd.upperAngle = degreesToRadians(85);
            jd.Initialize(ragDoll.torso1, ragDoll.upperArmR, new b2Vec2((startX + 18) / scale, (startY + 20) / scale));
            world.CreateJoint(jd);
            
            // Lower arm to upper arm
            // L
            jd.lowerAngle = degreesToRadians(-130);
            jd.upperAngle = degreesToRadians(10);
            jd.Initialize(ragDoll.upperArmL, ragDoll.lowerArmL, new b2Vec2((startX - 45) / scale, (startY + 20) / scale));
            world.CreateJoint(jd);
            // R
            jd.lowerAngle = degreesToRadians(-10);
            jd.upperAngle = degreesToRadians(130);
            jd.Initialize(ragDoll.upperArmR, ragDoll.lowerArmR, new b2Vec2((startX + 45) / scale, (startY + 20) / scale));
            world.CreateJoint(jd);
            
            // Shoulders/stomach
            jd.lowerAngle = degreesToRadians(-15);
            jd.upperAngle = degreesToRadians(15);
            jd.Initialize(ragDoll.torso1, ragDoll.torso2, new b2Vec2(startX / scale, (startY + 35) / scale));
            world.CreateJoint(jd);
            // Stomach/hips
            jd.Initialize(ragDoll.torso2, ragDoll.torso3, new b2Vec2(startX / scale, (startY + 50) / scale));
            world.CreateJoint(jd);
            
            // Torso to upper leg
            // L
            jd.lowerAngle = degreesToRadians(-25);
            jd.upperAngle = degreesToRadians(45);
            jd.Initialize(ragDoll.torso3, ragDoll.upperLegL, new b2Vec2((startX - 8) / scale, (startY + 72) / scale));
            world.CreateJoint(jd);
            // R
            jd.lowerAngle = degreesToRadians(-45);
            jd.upperAngle = degreesToRadians(25);
            jd.Initialize(ragDoll.torso3, ragDoll.upperLegR, new b2Vec2((startX + 8) / scale, (startY + 72) / scale));
            world.CreateJoint(jd);
            
            // Upper leg to lower leg
            // L
            jd.lowerAngle = degreesToRadians(-25);
            jd.upperAngle = degreesToRadians(115);
            jd.Initialize(ragDoll.upperLegL, ragDoll.lowerLegL, new b2Vec2((startX - 8) / scale, (startY + 105) / scale));
            world.CreateJoint(jd);
            // R
            jd.lowerAngle = degreesToRadians(-115);
            jd.upperAngle = degreesToRadians(25);
            jd.Initialize(ragDoll.upperLegR, ragDoll.lowerLegR, new b2Vec2((startX + 8) / scale, (startY + 105) / scale));
            world.CreateJoint(jd);
        }

    }
}