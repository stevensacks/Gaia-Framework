/**
 * VERSION: 2.3
 * DATE: 10/17/2009
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Tweening "autoAlpha" is exactly the same as tweening an object's "_alpha" except that it ensures 
 * that the object's "_visible" property is true until autoAlpha reaches zero at which point it will 
 * toggle the "_visible" property to false. That not only improves rendering performance in the Flash Player, 
 * but also hides MovieClips so that they don't interact with the mouse. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.AutoAlphaPlugin; <br />
 * 		TweenPlugin.activate([AutoAlphaPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 2, {autoAlpha:0}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.AutoAlphaPlugin extends VisiblePlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private var _target:Object;
		/** @private **/
		private var _ignoreVisible:Boolean;
		
		/** @private **/
		public function AutoAlphaPlugin() {
			super();
			this.propName = "autoAlpha";
			this.overwriteProps = ["_alpha","_visible"];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			_target = target;
			addTween(target, "_alpha", target._alpha, value, "_alpha");
			return true;
		}
		
		/** @private **/
		public function killProps(lookup:Object):Void {
			super.killProps(lookup);
			_ignoreVisible = Boolean(lookup._visible != undefined);
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			updateTweens(n);
			if (!_ignoreVisible) {
				_target._visible = Boolean(_target._alpha != 0);
			}
		}
	
}