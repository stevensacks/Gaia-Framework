/**
 * VERSION: 1.22
 * DATE: 10/2/2009
 * AS2 
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.core.*;
import com.greensock.plugins.*;
/**
 * To change a MovieClip's tint/color, set this to the hex value of the tint you'd like
 * to end up at (or begin at if you're using <code>TweenMax.from()</code>). An example hex value would be <code>0xFF0000</code>.<br /><br />
 * 
 * To remove a tint completely, use the RemoveTintPlugin (after activating it, you can just set <code>removeTint:true</code>) <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.TintPlugin; <br />
 * 		TweenPlugin.activate([TintPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {tint:0xFF0000}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.TintPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private var _color:Color;
		/** @private **/
		private var _ct:Object; //color transform
		/** @private **/
		private var _ignoreAlpha:Boolean;
		
		/** @private **/
		public function TintPlugin() {
			super();
			this.propName = "tint"; 
			this.overwriteProps = ["tint"];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (typeof(target) != "movieclip" && !(target instanceof TextField)) {
				return false;
			}
			var alpha:Number = (tween.vars._alpha != undefined) ? tween.vars._alpha : (tween.vars.autoAlpha != undefined) ? tween.vars.autoAlpha : target._alpha;
			var n:Number = Number(value);
			var end:Object = (value == null || tween.vars.removeTint == true) ? {rb:0, gb:0, bb:0, ab:0, ra:alpha, ga:alpha, ba:alpha, aa:alpha} : {rb:(n >> 16), gb:(n >> 8) & 0xff, bb:(n & 0xff), ra:0, ga:0, ba:0, aa:alpha};
			_ignoreAlpha = true;
			init(target, end);
			return true;
		}
		
		/** @private **/
		public function init(target:Object, end:Object):Void {
			_color = new Color(target);
			_ct = _color.getTransform();
			var i:Number, p:String;
			for (p in end) {
				if (_ct[p] != end[p]) {
					_tweens[_tweens.length] = new PropTween(_ct, p, _ct[p], end[p] - _ct[p], "tint", false);
				}
			}
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			var i:Number = _tweens.length, pt:PropTween;
			while (i--) {
				pt = _tweens[i];
				pt.target[pt.property] = pt.start + (pt.change * n);
			}
			if (_ignoreAlpha) {
				var ct:Object = _color.getTransform();
				_ct.aa = ct.aa;
				_ct.ab = ct.ab;
			}
			_color.setTransform(_ct);		
		}
	
}