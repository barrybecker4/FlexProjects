package com.becker.animation {
    
    import com.becker.animation.box2d.BoxWorld;
    import com.becker.animation.walking.*;
	import com.becker.animation.demos.*;
    
    import flash.utils.getDefinitionByName;
    
    import mx.containers.VBox;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    
    /**
     * The idea is to embedd a flash animation component inside a flex application.
     * 
     * @author Barry Becker
     */
    public class AnimationComponent extends VBox {
        private var _animatible:Animatible;
        private var _currentComponent:UIComponent;
        
        // need to reference or not included in swf unfortunately :(
        private var w1:AnimatedFilters;
        private var w2:Bouncing;
        private var w3:EaseToMouse;
        private var w4:MultiSegmentDrag;
        private var w5:PlayBall;
        private var w6:Bubbles2;
        private var w7:Fireworks;
        private var w8:MultiSpring;
        private var w9:Scribble;
        private var w10:ChainArray;
        private var w11:MultiBilliard2;
        private var w12:NodeGarden;
        private var w13:Bobbing;
        private var w14:OrbitDraw;
        private var w15:RealWalk;
        private var w16:DrawingApp;
        private var w17:MultiBounce3D;
        private var w18:BoxWorld;
        
        
        /**
         * @param sprite must pass in a sprite to wrap.
         */
        public function AnimationComponent() {    
            this.percentHeight = 100;
            this.percentWidth = 100;    
            this.setStyle("backgroundColor", 0xddccbb);                        
        }
        
        public function set animClass(className:String):void {
            
            var objClass:Class = getDefinitionByName(className) as Class;            
            if( objClass != null) {
                _animatible = Animatible(new objClass());                                    
            }
                        
            if (_currentComponent != null) {
                this.removeChild(_currentComponent);
            }
            _currentComponent = UIComponent(_animatible);    
            _currentComponent.percentWidth = 100;
            _currentComponent.percentHeight = 100;        
            this.addChild(_currentComponent);  
            
            _currentComponent.addEventListener(FlexEvent.CREATION_COMPLETE, init);                
        }
        
        /**
         * return Animatible, internal UIComponent.
         */
        public function get sprite():Animatible {
            return _animatible;
        }
        
        public function init(evt:FlexEvent):void {
            _animatible.startAnimating();
        }
           
    }
}