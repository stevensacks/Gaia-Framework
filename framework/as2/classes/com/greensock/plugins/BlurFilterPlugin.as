/**
 * VERSION: 2.0
 * DATE: 8/18/2009
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
import flash.filters.*;
/**
 * Tweens a BlurFilter. The following properties are available (you only need to define the ones you want to tween):
 * <code>
 * <ul>
 * 		<li> blurX : Number [0]</li>
 * 		<li> blurY : Number [0]</li>
 * 		<li> quality : Number [2]</li>
 * 		<li> index : Number</li>
 * 		<li> addFilter : Boolean [false]</li>
 * 		<li> remove : Boolean [false]</li>
 * </ul>
 * </code>
 * 	
 * Set <code>remove</code> to true if you want the filter to be removed when the tween completes. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.BlurFilterPlugin; <br />
 * 		TweenPlugin.activate([BlurFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {blurFilter:{blurX:10, blurY:10}}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.BlurFilterPlugin extends FilterPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		private static var _propNames:Array = ["blurX","blurY","quality"];
		
		/** @private **/
		public function BlurFilterPlugin() {
			super();
			this.propName = "blurFilter";
			this.overwriteProps = ["blurFilter"];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			_target = target;
			_type = BlurFilter;
			initFilter(value, new BlurFilter(0, 0, value.quality || 2), _propNames);
			return true;
		}
	
}