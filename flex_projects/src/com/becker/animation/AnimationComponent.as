package com.becker.animation
{
	import com.becker.animation.walking.*;
	
	import flash.utils.getDefinitionByName;
	
	import mx.containers.VBox;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class AnimationComponent extends VBox
	{
		private var _sprite:Animatible;
		
		// need to reference or not in swf :(
		private var w1:RealWalk;
		private var w2:DrawingApp;
		private var w3:MultiBilliard2;
		private var w4:ChainArray;
		private var w5:PlayBall;
		private var w6:MultiBounce3D;
		private var w7:NodeGarden;
		private var w8:Bobbing;
		private var w9:MultiSegmentDrag;
		private var w10:MultiSpring;
		private var w11:Fireworks;
		
		/**
		 * @param sprite must pass in a sprite to wrap.
		 */
		public function AnimationComponent()
		{	
			this.percentHeight = 100;
			this.percentWidth = 100;	
			this.setStyle("backgroundColor", 0xddccbb);						
		}
		
		public function set animClass(className:String):void
		{
			var objClass:Class = getDefinitionByName(className) as Class;			
			if( objClass != null) 	
			{
				_sprite = Animatible(new objClass());									
		    }
						
			var comp:UIComponent = UIComponent(_sprite);	
			comp.percentWidth = 100;
			comp.percentHeight = 100;		
            this.addChild(comp);            
            
			comp.addEventListener(FlexEvent.CREATION_COMPLETE, init);				
			//setTimeout(init, 200);   
		}
		
		public function init(evt:FlexEvent):void
		{
			_sprite.startAnimating();
		}
	}
}