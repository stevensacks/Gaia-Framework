/**
 * Stores information about Array tweens. <br /><br />
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
class com.greensock.plugins.helpers.ArrayTweenInfo {
		public var index:Number;
		public var start:Number;
		public var change:Number;
		
		public function ArrayTweenInfo(index:Number, start:Number, change:Number) {
			this.index = index;
			this.start = start;
			this.change = change;
		}
}