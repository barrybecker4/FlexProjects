package com.becker.animation.box2d.builders
{
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.sprites.AbstractShape;
    
    import mx.core.UIComponent;
    
    public class AbstractBuilder  {
        
        /** Turn on to avoid tunneling */
        private static const IS_BULLET:Boolean = false;
        
        protected var world:b2World;
        protected var canvas:UIComponent;
        protected var scale:Number;
        
        
        public function AbstractBuilder(world:b2World, canvas:UIComponent, scale:Number) {
            this.world = world; 
            this.canvas = canvas;
            this.scale = scale;
        }
                      
        protected function addShape(fixtureDef:b2FixtureDef, bodyDef:b2BodyDef):b2Body {           
          
            var body:b2Body = world.CreateBody(bodyDef);
            body.SetBullet(IS_BULLET);
            
            body.CreateFixture(fixtureDef);
            //body.ResetMassData();
            canvas.addChild(bodyDef.userData);

            return body;
        }
        
        /** Will just be visible without physical presence. */
        protected function addShapeWithoutFixture(fixtureDef:b2FixtureDef, bodyDef:b2BodyDef):b2Body {           
          
            var body:b2Body = world.CreateBody(bodyDef);
            canvas.addChild(bodyDef.userData);
            return body;
        }
        
        public static function degreesToRadians(angle:Number):Number {
            return angle * (180.0/Math.PI);
        }
    }
}