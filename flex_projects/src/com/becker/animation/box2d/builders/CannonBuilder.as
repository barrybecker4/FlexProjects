package com.becker.animation.box2d.builders {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.box2d.builders.items.Cannon;
    import com.becker.animation.sprites.Bazooka;
    import com.becker.common.PhysicalParameters;
    import mx.core.UIComponent;
    
    /**
     * Build a cannon with manipulable parameters
     */
    public class CannonBuilder extends AbstractBuilder {
        
        private static const SIZE:Number = 2.5;
     
        private var shapeBuilder:BasicShapeBuilder;
        private var params:PhysicalParameters;    
        
    
        /** Constructor */
        public function CannonBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            super(world, canvas, scale);
            shapeBuilder = new BasicShapeBuilder(world, canvas, scale);
        }
        
        public function buildInstance(startX:Number, startY:Number, 
                                      params:PhysicalParameters):Cannon {
 
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.type = b2Body.b2_dynamicBody;
            
            bodyDef.position.Set(startX, startY);
            
            var cannonBody:b2Body = 
                shapeBuilder.buildBlock(10, 20, bodyDef, params.density, params.friction, params.restitution);
            
            var bazooka:Bazooka = new Bazooka(5, 8);
            canvas.addChild(bazooka);
            //bazooka.gotoAndStop(1);
            
            var ground_sensor:b2FixtureDef = new b2FixtureDef();
            ground_sensor.isSensor = true;
            ground_sensor.userData = "groundsensor";
            
            var sensorShape:b2PolygonShape = new b2PolygonShape();
            sensorShape.SetAsOrientedBox(10 / scale, 5 / scale, new b2Vec2(0, 27 / scale), 0);
            ground_sensor.shape = sensorShape;
            
            var body:b2Body = world.CreateBody(bodyDef);
            body.CreateFixture(ground_sensor);
            body.ResetMassData() //SetMassFromShapes();

            return new Cannon(cannonBody, bazooka, ground_sensor);
        }
    }
}