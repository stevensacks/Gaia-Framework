/**
 * Stores information about PhysicsPropsPlugin tweens. <br /><br />
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
class com.greensock.plugins.helpers.PhysicsProp {
		public var property:String;
		public var start:Number;
		public var velocity:Number;
		public var acceleration:Number;
		public var friction:Number;
		public var v:Number; //used to track the current velocity as we iterate through friction-based tween algorithms
		public var a:Number; //only used in friction-based tweens
		public var value:Number; //used to track the current property value in friction-based tweens
		
		public function PhysicsProp(property:String, start:Number, velocity:Number, acceleration:Number, friction:Number, stepsPerTimeUnit:Number) {
			this.property = property;
			this.start = this.value = start;
			this.velocity = velocity || 0;
			this.v = this.velocity / stepsPerTimeUnit;
			if (acceleration || acceleration == 0) {
				this.acceleration = acceleration;
				this.a = this.acceleration / (stepsPerTimeUnit * stepsPerTimeUnit);
			} else {
				this.acceleration = this.a = 0;
			}
			this.friction = (friction || friction == 0) ? 1 - friction : 1;
		}	
}