/**
 * VERSION: 1.12
 * DATE: 10/2/2009
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Although hex colors are technically numbers, if you try to tween them conventionally, 
 * you'll notice that they don't tween smoothly. To tween them properly, the red, green, and 
 * blue components must be extracted and tweened independently. The HexColorsPlugin makes it easy. 
 * To tween a property of your object that's a hex color to another hex color, just pass a hexColors 
 * Object with properties named the same as your object's hex color properties. For example, 
 * if myObject has a "myHexColor" property that you'd like to tween to red (<code>0xFF0000</code>) over the 
 * course of 2 seconds, you'd do:<br /><br /><code>
 * 	
 * 	TweenMax.to(myObject, 2, {hexColors:{myHexColor:0xFF0000}});<br /><br /></code>
 * 	
 * You can pass in any number of hexColor properties. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.HexColorsPlugin; <br />
 * 		TweenPlugin.activate([HexColorsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(myObject, 2, {hexColors:{myHexColor:0xFF0000}}); <br /><br /></code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.HexColorsPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private var _colors:Array;
		
		/** @private **/
		public function HexColorsPlugin() {
			super();
			this.propName = "hexColors";
			this.overwriteProps = [];
			_colors = [];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			for (var p:String in value) {
				initColor(target, p, Number(target[p]), Number(value[p]));
			}
			return true;
		}
		
		/** @private **/
		public function initColor(target:Object, propName:String, start:Number, end:Number):Void {
			if (start != end) {
				var r:Number = start >> 16;
				var g:Number = (start >> 8) & 0xff;
				var b:Number = start & 0xff;
				_colors[_colors.length] = [target, 
										   propName, 
										   r,
										   (end >> 16) - r,
										   g,
										   ((end >> 8) & 0xff) - g,
										   b,
										   (end & 0xff) - b];
				this.overwriteProps[this.overwriteProps.length] = propName;
			}
		}
		
		/** @private **/
		public function killProps(lookup:Object):Void {
			var i:Number = _colors.length;
			while (i--) {
				if (lookup[_colors[i][1]] != undefined) {
					_colors.splice(i, 1);
				}
			}
			super.killProps(lookup);
		}	
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			var i:Number = _colors.length, a:Array;
			while (i--) {
				a = _colors[i];
				a[0][a[1]] = ((a[2] + (n * a[3])) << 16 | (a[4] + (n * a[5])) << 8 | (a[6] + (n * a[7])));
			}
		}
	
}