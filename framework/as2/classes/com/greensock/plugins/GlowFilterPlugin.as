/**
 * VERSION: 2.01
 * DATE: 10/2/2009
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
import flash.filters.*;
/**
 * Tweens a GlowFilter. The following properties are available (you only need to define the ones you want to tween):
 * <code>
 * <ul>
 * 		<li> color : Number [0x000000]</li>
 * 		<li> alpha :Number [0]</li>
 * 		<li> blurX : Number [0]</li>
 * 		<li> blurY : Number [0]</li>
 * 		<li> strength : Number [1]</li>
 * 		<li> quality : Number [2]</li>
 * 		<li> inner : Boolean [false]</li>
 * 		<li> knockout : Boolean [false]</li>
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
 * 		import com.greensock.plugins.GlowFilterPlugin; <br />
 * 		TweenPlugin.activate([GlowFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {glowFilter:{color:0x00FF00, blurX:10, blurY:10, strength:1, alpha:1}});<br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.GlowFilterPlugin extends FilterPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		private static var _propNames:Array = ["color","alpha","blurX","blurY","strength","quality","inner","knockout"];
		
		/** @private **/
		public function GlowFilterPlugin() {
			super();
			this.propName = "glowFilter";
			this.overwriteProps = ["glowFilter"];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			_target = target;
			_type = GlowFilter;
			initFilter(value, new GlowFilter(0xFFFFFF, 0, 0, 0, value.strength || 1, value.quality || 2, value.inner, value.knockout), _propNames);
			return true;
		}
		
}