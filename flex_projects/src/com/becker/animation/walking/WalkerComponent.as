package com.becker.animation.walking
{
	import mx.containers.VBox;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class WalkerComponent extends VBox
	{		
		// need to reference or not in swf :(
		public var walker:RealWalk;
		
		/**
		 * Must put the sprite in a UI component for use in flex.
		 */
		public function WalkerComponent()
		{	
			this.percentHeight = 100;
			this.percentWidth = 100;	
			this.setStyle("backgroundColor", 0xaabbcc);	
				
		    walker = new RealWalk();							
		   			
			var comp:UIComponent = UIComponent(walker);	
			comp.percentWidth = 100;
			comp.percentHeight = 100;		
            this.addChild(comp);            
            
			comp.addEventListener(FlexEvent.CREATION_COMPLETE, init);												
		}
	
		
		public function init(evt:FlexEvent):void
		{
			walker.startAnimating();
		}
		

	}
}