package com.becker.animation.box2d.builders
{
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.Shapes.b2ShapeDef;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;
    
    import com.becker.animation.sprites.Circle;
    import com.becker.animation.sprites.Rectangle;
    
    import mx.core.UIComponent;
    
    public class AbstractBuilder 
    {
        
        protected var world:b2World;
        protected var canvas:UIComponent;
        protected var scale:Number;
        
        
        public function AbstractBuilder(world:b2World, canvas:UIComponent, scale:Number)
        {
            this.world = world; 
            this.canvas = canvas;
            this.scale = scale;
        }
        
              
        protected function addShape(shapeDef:b2ShapeDef, bodyDef:b2BodyDef):b2Body
        {           
            //bodyDef.userData.scale = initialScale;
            canvas.addChild(bodyDef.userData);
            
            var body:b2Body = world.CreateBody(bodyDef);
            body.CreateShape(shapeDef);
            body.SetMassFromShapes();    
            return body;
        }
        
        public static function degreesToRadians(angle:Number):Number
        {
            return angle * (180.0/Math.PI);
        }
 
    }
}