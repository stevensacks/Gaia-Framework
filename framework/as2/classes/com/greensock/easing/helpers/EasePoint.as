/**
 * @private
 * Stores information about points related to an easing equation like RoughEase. <br /><br />
 * 
 * <b>Copyright 2010, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
class com.greensock.easing.helpers.EasePoint {
	public var time:Number;
	public var gap:Number;
	public var value:Number;
	public var change:Number;
	public var next:EasePoint;
	public var prev:EasePoint;
	
	public function EasePoint(time:Number, value:Number, next:EasePoint) {
		this.time = time;
		this.value = value;
		if (next) {
			this.next = next;
			next.prev = this;
			this.change = next.value - value;
			this.gap = next.time - time;
		}
	}
}