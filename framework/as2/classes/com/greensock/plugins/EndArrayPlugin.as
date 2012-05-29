/**
 * VERSION: 1.53
 * DATE: 10/2/2009
 * AS2 
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
import com.greensock.plugins.helpers.*;
/**
 * Tweens numbers in an Array. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.EndArrayPlugin; <br />
 * 		TweenPlugin.activate([EndArrayPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		var myArray:Array = [1,2,3,4];<br />
 * 		TweenLite.to(myArray, 1.5, {endArray:[10,20,30,40]}); <br /><br />
 * </code>
 *
 * Bytes added to SWF: 306 (not including dependencies)<br /><br />
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
class com.greensock.plugins.EndArrayPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private var _a:Array;
		/** @private **/
		private var _info:Array;
		
		/** @private **/
		public function EndArrayPlugin() {
			super();
			this.propName = "endArray"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = ["endArray"];
			_info = [];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (!(target instanceof Array) || !(value instanceof Array)) {
				return false;
			}
			init([target][0], [value][0]); //prevents compiler errors
			return true;
		}
		
		/** @private **/
		public function init(start:Array, end:Array):Void {
			_a = start;
			var i:Number = end.length;
			while (i--) {
				if (start[i] != end[i] && start[i] != undefined) {
					_info[_info.length] = new ArrayTweenInfo(i, _a[i], end[i] - _a[i]);
				}
			}
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			var i:Number = _info.length, ti:ArrayTweenInfo;
			if (this.round) {
				while (i--) {
					ti = _info[i];
					_a[ti.index] = Math.round(ti.start + (ti.change * n));
				}
			} else {
				while (i--) {
					ti = _info[i];
					_a[ti.index] = ti.start + (ti.change * n);
				}
			}
		}
	
}
