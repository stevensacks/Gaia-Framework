/**
 * VERSION: 1.2
 * DATE: 2011-02-03
 * AS2
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Tweens a MovieClip to a particular frame label. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.FrameLabelPlugin; <br />
 * 		TweenPlugin.activate([FrameLabelPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {frameLabel:"myLabel"}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.FrameLabelPlugin extends FramePlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public function FrameLabelPlugin() {
			super();
			this.propName = "frameLabel";
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (typeof(tween.target) != "movieclip") {
				return false;
			}
			
			_target = MovieClip(target);
			this.frame = _target._currentframe;
			var mc:MovieClip = _target.duplicateMovieClip("__frameLabelPluginTempMC", _target._parent.getNextHighestDepth()); //we don't want to gotAndStop() on the original MovieClip because it would interfere with playback if it's currently playing. We wouldn't know whether or not to gotoAndStop() or gotoAndPlay() back to the original frame afterwards. So we duplicate it and then remove the duplicate when we're done.
			mc.gotoAndStop(value);
			var endFrame:Number = mc._currentframe;
			mc.removeMovieClip();
			
			if (this.frame != endFrame) {
				addTween(this, "frame", this.frame, endFrame, "frame");
			}
			return true;
		}
		
}