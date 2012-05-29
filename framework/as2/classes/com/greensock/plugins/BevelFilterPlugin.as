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
 * Tweens a BevelFilter. The following properties are available (you only need to define the ones you want to tween): <br />
 * <code>
 * <ul>
 * 		<li> distance : Number [0]</li>
 * 		<li> angle : Number [0]</li>
 * 		<li> highlightColor : Number [0xFFFFFF]</li>
 * 		<li> highlightAlpha : Number [0.5]</li>
 * 		<li> shadowColor : Number [0x000000]</li>
 * 		<li> shadowAlpha :Number [0.5]</li>
 * 		<li> blurX : Number [2]</li>
 * 		<li> blurY : Number [2]</li>
 * 		<li> strength : Number [0]</li>
 * 		<li> quality : Number [2]</li>
 * 		<li> index : Number</li>
 * 		<li> addFilter : Boolean [false]</li>
 * 		<li> remove : Boolean [false]</li>
 * </ul>
 * </code>
 * 
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.BevelFilterPlugin; <br />
 * 		TweenPlugin.activate([BevelFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {bevelFilter:{blurX:10, blurY:10, distance:6, angle:45, strength:1}});<br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.BevelFilterPlugin extends FilterPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		private static var _propNames:Array = ["distance","angle","highlightColor","highlightAlpha","shadowColor","shadowAlpha","blurX","blurY","strength","quality"];
		
		/** @private **/
		public function BevelFilterPlugin() {
			super();
			this.propName = "bevelFilter";
			this.overwriteProps = ["bevelFilter"];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			_target = target;
			_type = BevelFilter;
			initFilter(value, new BevelFilter(0, 0, 0xFFFFFF, 0.5, 0x000000, 0.5, 2, 2, 0, value.quality || 2), _propNames);
			return true;
		}
	
}