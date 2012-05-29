/**
 * VERSION: 1.12
 * DATE: 10/2/2009
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Tweens the volume of a MovieClip or Sound. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.VolumePlugin; <br />
 * 		TweenPlugin.activate([VolumePlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {volume:0}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.VolumePlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public var volume:Number;
		
		/** @private **/
		private var _sound:Sound;
		
		/** @private **/
		public function VolumePlugin() {
			super();
			this.propName = "volume";
			this.overwriteProps = ["volume"];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (isNaN(value) || (typeof(target) != "movieclip" && !(target instanceof Sound))) {
				return false;
			}
			_sound = (typeof(target) == "movieclip") ? new Sound(target) : Sound(target);
			this.volume = _sound.getVolume();
			addTween(this, "volume", this.volume, value, "volume");
			return true;
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			updateTweens(n);
			_sound.setVolume(this.volume);
		}
	
}