/**
 * VERSION: 0.1
 * DATE: 2010-04-29
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.GreenSock.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Tweens a MovieClip forward to a particular frame number, wrapping it if/when it reaches the end
 * of the timeline. For example, if your MovieClip has 20 frames total and it is currently at frame 10
 * and you want tween to frame 5, a normal frame tween would go backwards from 10 to 5, but a frameForward
 * would go from 10 to 20 (the end) and wrap to the beginning and continue tweening from 1 to 5. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.~~; <br />
 * 		TweenPlugin.activate([FrameForwardPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {frameForward:5}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.FrameForwardPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private var _start:Number;
		/** @private **/
		private var _change:Number;
		/** @private **/
		private var _max:Number;
		/** @private **/
		private var _target:MovieClip;
		/** @private Allows FrameBackwardPlugin to extend this class and only use an extremely small amount of kb (because the functionality is combined here) **/
		private var _backward:Boolean;
		
		
		/** @private **/
		public function FrameForwardPlugin() {
			super();
			this.propName = "frameForward";
			this.overwriteProps = ["frame","frameLabel","frameForward","frameBackward"];
			this.round = true;
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if ((typeof(target) != "movieclip") || isNaN(value)) {
				return false;
			}
			_target = MovieClip(target);
			_start = _target._currentframe;
			_max = _target._totalframes;
			_change = (typeof(value) == "number") ? Number(value) - _start : Number(value);
			if (!_backward && _change < 0) {
				_change += _max;
			} else if (_backward && _change > 0) {
				_change -= _max;
			}
			return true;
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			var frame:Number = (_start + (_change * n)) % _max;
			if (frame < 0.5 && frame >= -0.5) {
				frame = _max;
			} else if (frame < 0) {
				frame += _max;
			}
			_target.gotoAndStop( Math.floor(frame + 0.5) );
		}
		
}