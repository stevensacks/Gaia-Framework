/**
 * VERSION: 1.02
 * DATE: 10/2/2009
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * ScalePlugin combines _xscale and _yscale into one "scale" property. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.ScalePlugin; <br />
 * 		TweenPlugin.activate([ScalePlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {scale:200});  //tweens horizontal and vertical scale simultaneously <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.ScalePlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0;

		/** @private **/
		private var _target:Object;
		/** @private **/
		private var _startX:Number;
		/** @private **/
		private var _changeX:Number;
		/** @private **/
		private var _startY:Number;
		/** @private **/
		private var _changeY:Number;
  
		/** @private **/
		public function ScalePlugin() {
			super();
			this.propName = "scale";
			this.overwriteProps = ["scaleX", "scaleY", "width", "height"];
		}
  
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (target._xscale == undefined) {
				return false;
			}
 			_target = target;
 			_startX = _target._xscale;
 			_startY = _target._yscale;
 			if (typeof(value) == "number") {
 				_changeX = Number(value) - _startX;
 				_changeY = Number(value) - _startY;
 			} else {
 				_changeX = _changeY = Number(value);
 			}
			return true;
		}
		
		/** @private **/
		public function killProps(lookup:Object):Void {
			var i:Number = this.overwriteProps.length;
			while (i--) {
				if (lookup[this.overwriteProps[i]] != undefined) { //if any of the properties are found in the lookup, this whole plugin instance should be essentially deactivated. To do that, we must empty the overwriteProps Array.
					this.overwriteProps = [];
					return;
				}
			}
		}
  
		/** @private **/
		public function set changeFactor(n:Number):Void {
			_target._xscale = _startX + (n * _changeX);
			_target._yscale = _startY + (n * _changeY);
		}
}