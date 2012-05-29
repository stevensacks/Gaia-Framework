/**
 * VERSION: 1.12
 * DATE: 10/2/2009
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Tweens a MovieClip to a particular frame number. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.FramePlugin; <br />
 * 		TweenPlugin.activate([FramePlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {frame:125}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.FramePlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public var frame:Number;
		/** @private **/
		private var _target:MovieClip;
		
		/** @private **/
		public function FramePlugin() {
			super();
			this.propName = "frame";
			this.overwriteProps = ["frame"];
			this.round = true;
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (typeof(target) != "movieclip" || isNaN(value)) {
				return false;
			}
			_target = MovieClip(target);
			this.frame = _target._currentframe;
			addTween(this, "frame", this.frame, value, "frame");
			return true;
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			updateTweens(n);
			_target.gotoAndStop(this.frame);
		}
		
}