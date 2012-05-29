/**
 * VERSION: 1.62
 * DATE: 10/2/2009
 * AS2
 * UPDATES AND MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Ever wanted to tween ColorTransform properties of a MovieClip to do advanced effects like overexposing, altering
 * the brightness or setting the percent/amount of tint? Or maybe tween individual ColorTransform 
 * properties like redMultiplier, redOffset, blueMultiplier, blueOffset, etc. ColorTransformPlugin gives you an easy way to 
 * do just that. <br /><br />
 * 
 * <b>PROPERTIES:</b><br />
 * <ul>
 * 		<li><code> tint (or color) : Number</code> - Color of the tint. Use a hex value, like 0xFF0000 for red.</li>
 * 		<li><code> tintAmount : Number</code> - Number between 0 and 1. Works with the "tint" property and indicats how much of an effect the tint should have. 0 makes the tint invisible, 0.5 is halfway tinted, and 1 is completely tinted.</li>
 * 		<li><code> brightness : Number</code> - Number between 0 and 2 where 1 is normal brightness, 0 is completely dark/black, and 2 is completely bright/white</li>
 * 		<li><code> exposure : Number</code> - Number between 0 and 2 where 1 is normal exposure, 0, is completely underexposed, and 2 is completely overexposed. Overexposing an object is different then changing the brightness - it seems to almost bleach the image and looks more dynamic and interesting (subjectively speaking).</li> 
 * 		<li><code> redOffset : Number</code></li>
 * 		<li><code> greenOffset : Number</code></li>
 * 		<li><code> blueOffset : Number</code></li>
 * 		<li><code> alphaOffset : Number</code></li>
 * 		<li><code> redMultiplier : Number</code></li>
 * 		<li><code> greenMultiplier : Number</code></li>
 * 		<li><code> blueMultiplier : Number</code></li>
 * 		<li><code> alphaMultiplier : Number</code> </li>
 * </ul><br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.ColorTransformPlugin; <br />
 * 		TweenPlugin.activate([ColorTransformPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {colorTransform:{tint:0xFF0000, tintAmount:0.5}}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.ColorTransformPlugin extends TintPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		public function ColorTransformPlugin() {
			super();
			this.propName = "colorTransform"; 
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (typeof(target) != "movieclip" && !(target instanceof TextField)) {
				return false;
			}
			var color:Color = new Color(target);
			var end:Object = color.getTransform();
			
			if (value.redMultiplier != undefined) {
				end.ra = value.redMultiplier * 100;
			}
			if (value.greenMultiplier != undefined) {
				end.ga = value.greenMultiplier * 100;
			}
			if (value.blueMultiplier != undefined) {
				end.ba = value.blueMultiplier * 100;
			}
			if (value.alphaMultiplier != undefined) {
				end.aa = value.alphaMultiplier * 100;
			}
			if (value.redOffset != undefined) {
				end.rb = value.redOffset;
			}
			if (value.greenOffset != undefined) {
				end.gb = value.greenOffset;
			}
			if (value.blueOffset != undefined) {
				end.bb = value.blueOffset;
			}
			if (value.alphaOffset != undefined) {
				end.ab = value.alphaOffset;
			}
			if (!isNaN(value.tint) || !isNaN(value.color)) {
				var tint:Object = (!isNaN(value.tint)) ? value.tint : value.color; //make it an object so that it can be null (Numbers can't)
				if (tint != null) {
					/* to clear the ColorTransform (make it return to normal), use this...
					var alpha:Number = target._alpha;
					end.rb = 0;
					end.gb = 0;
					end.bb = 0;
					end.ra = alpha;
					end.ga = alpha;
					end.ba = alpha;
					end.aa = alpha;
					*/
					end.rb = (Number(tint) >> 16);
					end.gb = (Number(tint) >> 8) & 0xff;
					end.bb = (Number(tint) & 0xff);
					end.ra = 0;
					end.ga = 0;
					end.ba = 0;
				}
			}
			
			if (!isNaN(value.tintAmount)) {
				var ratio:Number = value.tintAmount / (1 - ((end.ra + end.ga + end.ba) / 300));
				end.rb *= ratio;
				end.gb *= ratio;
				end.bb *= ratio;
				end.ra = end.ga = end.ba = (1 - value.tintAmount) * 100;
			} else if (!isNaN(value.exposure)) {
				end.rb = end.gb = end.bb = 255 * (value.exposure - 1);
				end.ra = end.ga = end.ba = 100;
			} else if (!isNaN(value.brightness)) {
				end.rb = end.gb = end.bb = Math.max(0, (value.brightness - 1) * 255);
				end.ra = end.ga = end.ba = (1 - Math.abs(value.brightness - 1)) * 100;
			}
			
			if (tween.vars._alpha != undefined && value.alphaMultiplier == undefined) {
				end.aa = tween.vars._alpha;
				tween.killVars({alpha:1});
			}
			
			init(target, end);
			
			return true;
		}
	
}