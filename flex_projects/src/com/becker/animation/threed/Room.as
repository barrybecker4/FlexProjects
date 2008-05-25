package com.becker.animation.threed
{
	public class Room extends Object
	{
		public var top:Number;
		public var bottom:Number;
		public var left:Number;
		public var right:Number;
		public var front:Number;
		public var back:Number;
			
		public function Room(size:Number)
		{
			top = -size;			
			bottom = size;
			left = -size;
			right = size;
			front = size;
			back = -size;				
		}		
	}
}