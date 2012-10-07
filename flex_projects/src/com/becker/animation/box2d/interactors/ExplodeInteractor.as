package com.becker.animation.box2d.interactors {
    
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2FixtureDef;
    import Box2D.Dynamics.b2World;
    import com.becker.animation.sprites.ExplodableShape;
    import com.becker.animation.box2d.Exploder;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import mx.core.UIComponent;
    
    /**
     * Lets you blow up stuff by clicking on it.
     */
    public class ExplodeInteractor implements Interactor {
                
        private var world:b2World;
        private var canvas:UIComponent;
        private var scale:Number;
        
        
        /** Constructor */
        public function ExplodeInteractor(world:b2World, canvas:UIComponent, scale:Number ) {
            this.world = world;
            this.canvas = canvas;
            this.scale = scale;
            canvas.stage.addEventListener(MouseEvent.MOUSE_DOWN, doExplosion);
        }
        
        public function removeHandlers():void {
            canvas.stage.removeEventListener(MouseEvent.MOUSE_DOWN, doExplosion);
        }
        
        /** function to create an explosion */
        private function doExplosion(e:MouseEvent):void {
            
            var clickedBody:b2Body = 
                GetBodyAtXY(new b2Vec2(canvas.mouseX / scale, canvas.mouseY / scale));
                
            if (clickedBody != null) {
                var exploder:Exploder = new Exploder(world, canvas, scale);
                exploder.explodeBody(clickedBody, canvas.mouseX, canvas.mouseY);
            }
        }

        /**
         * this function returns the body at a X,Y coordinate without using a temp body like the one in
         * the original Box2D distribution. It uses QueryPoint method.
         * @return the body ad X,Y coordinate or null.
         */ 
        private function GetBodyAtXY(coordinate:b2Vec2):b2Body {
            var touchedBody:b2Body = null;
            world.QueryPoint(GetBodyCallback, coordinate);
            function GetBodyCallback(fixture:b2Fixture):Boolean {
                var shape:b2Shape = fixture.GetShape();
                var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(),coordinate);
                if (inside) {
                    touchedBody = fixture.GetBody();
                    return false;
                }
                return true;
            }
            return touchedBody;
        }
    }
}

