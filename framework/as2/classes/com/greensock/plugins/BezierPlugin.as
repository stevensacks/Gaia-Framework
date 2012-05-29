/**
 * VERSION: 2.12
 * DATE: 10/2/2009
 * AS2
 * UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Bezier tweening allows you to tween in a non-linear way. For example, you may want to tween
 * a MovieClip's position from the origin (0,0) 500 pixels to the right (500,0) but curve downwards
 * through the middle of the tween. Simply pass as many objects in the bezier Array as you'd like, 
 * one for each "control point" (see documentation on Flash's curveTo() drawing method for more
 * about how control points work).<br /><br />
 * 
 * Keep in mind that you can bezier tween ANY properties, not just _x/_y. <br /><br />
 * 
 * Also, if you'd like to rotate the target in the direction of the bezier path, 
 * use the <code>orientToBezier</code> special property. In order to alter a rotation property accurately, 
 * TweenLite/Max needs 5 pieces of information: <br />
 * <ol>
 * 		<li> Position property 1 (typically <code>"_x"</code>)</li>
 * 		<li> Position property 2 (typically <code>"_y"</code>)</li>
 * 		<li> Rotational property (typically <code>"_rotation"</code>)</li>
 * 		<li> Number of degrees to add (optional - makes it easy to orient your MovieClip properly)</li>
 * 		<li> Tolerance (default is 0.01, but increase this if the rotation seems to jitter during the tween)</li>
 * </ol><br />
 * 
 * The <code>orientToBezier</code> property should be an Array containing one Array for each set of these values. 
 * For maximum flexibility, you can pass in any number of Arrays inside the container Array, one 
 * for each rotational property. This can be convenient when working in 3D because you can rotate
 * on multiple axis. If you're doing a standard 2D _x/_y tween on a bezier, you can simply pass 
 * in a boolean value of true and TweenLite/Max will use a typical setup, <code>[["_x", "_y", "_rotation", 0, 0.01]]</code>. 
 * Hint: Don't forget the container Array (notice the double outer brackets)<br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.BezierPlugin; <br />
 * 		TweenPlugin.activate([BezierPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 3, {bezier:[{_x:250, _y:50}, {_x:500, _y:0}]}); //makes my_mc travel through 250,50 and end up at 500,0. <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.BezierPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private static var _RAD2DEG:Number = 180 / Math.PI; //precalculate for speed
		
		/** @private **/
		private var _target:Object;
		/** @private **/
		private var _orientData:Array;
		/** @private **/
		private var _orient:Boolean;
		/** @private used for orientToBezier projections **/
		private var _future:Object; 
		/** @private **/
		private var _beziers:Object;
		
		/** @private **/
		public function BezierPlugin() {
			super();
			this.propName = "bezier"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = []; //will be populated in init()
			_future = {};
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			if (!(value instanceof Array)) {
				return false;
			}
			init(tween, [value][0], false); // [value][0] instead of simply value to avoid compiler error
			return true;
		}
		
		/** @private **/
		private function init(tween:TweenLite, beziers:Array, through:Boolean):Void {
			_target = tween.target;
			var enumerables:Object = tween.vars; 
			if (enumerables.orientToBezier == true) {
				_orientData = [["_x", "_y", "_rotation", 0, 0.01]];
				_orient = true;
			} else if (enumerables.orientToBezier instanceof Array) {
				_orientData = enumerables.orientToBezier;
				_orient = true;
			}
			var props:Object = {}, i:Number, p:String, killVarsLookup:Object;
			for (i = 0; i < beziers.length; i++) {
				for (p in beziers[i]) {
					if (props[p] == undefined) {
						props[p] = [tween.target[p]];
					}
					if (typeof(beziers[i][p]) == "number") {
						props[p].push(beziers[i][p]);
					} else {
						props[p].push(tween.target[p] + Number(beziers[i][p])); //relative value
					}
				}
			}
			for (p in props) {
				this.overwriteProps[this.overwriteProps.length] = p;
				if (enumerables[p] != undefined) {
					if (typeof(enumerables[p]) == "number") {
						props[p].push(enumerables[p]);
					} else {
						props[p].push(tween.target[p] + Number(enumerables[p])); //relative value
					}
					killVarsLookup = {};
					killVarsLookup[p] = true;
					tween.killVars(killVarsLookup, false);
					delete enumerables[p]; //in case TweenLite/Max hasn't reached the enumerable yet in its init() function. This prevents normal tweens from getting created for the properties that should be controled with the BezierPlugin.
				}
			}
			_beziers = parseBeziers(props, through);
		}
		
		/**
		 * Helper method for translating control points into bezier information.
		 * 
		 * @param props Object containing a property corresponding to each one you'd like bezier paths for. Each property's value should be a single Array with the numeric point values (i.e. <code>props.x = [12,50,80]</code> and <code>props.y = [50,97,158]</code>). 
		 * @param through If you want the paths drawn THROUGH the supplied control points, set this to true.
		 * @return A new object with an Array of values for each property. The first element in the Array is the start value, the second is the control point, and the 3rd is the end value. (i.e. <code>returnObject.x = [[12, 32, 50}, [50, 65, 80]]</code>)
		 */
		public static function parseBeziers(props:Object, through:Boolean):Object { 
			var i:Number, a:Array, b:Object, p:String;
			var all:Object = {};
			if (through == true) {
				for (p in props) {
					a = props[p];
					all[p] = b = [];
					if (a.length > 2) {
						b[b.length] = [a[0], a[1] - ((a[2] - a[0]) / 4), a[1]];
						for (i = 1; i < a.length - 1; i++) {
							b[b.length] = [a[i], a[i] + (a[i] - b[i - 1][1]), a[i + 1]];
						}
					} else {
						b[b.length] = [a[0], (a[0] + a[1]) / 2, a[1]];
					}
				}
			} else {
				for (p in props) {
					a = props[p];
					all[p] = b = [];
					if (a.length > 3) {
						b[b.length] = [a[0], a[1], (a[1] + a[2]) / 2];
						for (i = 2; i < a.length - 2; i++) {
							b[b.length] = [b[i - 2][2], a[i], (a[i] + a[i + 1]) / 2];
						}
						b[b.length] = [b[b.length - 1][2], a[a.length - 2], a[a.length - 1]];
					} else if (a.length == 3) {
						b[b.length] = [a[0], a[1], a[2]];
					} else if (a.length == 2) {
						b[b.length] = [a[0], (a[0] + a[1]) / 2, a[1]];
					}
				}
			}
			return all;
		}
		
		/** @private **/
		public function killProps(lookup:Object):Void {
			for (var p:String in _beziers) {
				if (lookup[p] != undefined) {
					delete _beziers[p];
				}
			}
			super.killProps(lookup);
		}	
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			var i:Number, p:String, b:Object, t:Number, segments:Number, val:Number, neg:Number;
			if (n == 1) { //to make sure the end values are EXACTLY what they need to be.
				for (p in _beziers) {
					i = _beziers[p].length - 1;
					_target[p] = _beziers[p][i][2];
				}
			} else {
				for (p in _beziers) {
					segments = _beziers[p].length;
					if (n < 0) {
						i = 0;
					} else if (n >= 1) {
						i = segments - 1;
					} else {
						i = (segments * n) >> 0;
					}
					t = (n - (i * (1 / segments))) * segments;
					b = _beziers[p][i];
					if (this.round) {
						_target[p] = Math.round(b[0] + t * (2 * (1 - t) * (b[1] - b[0]) + t * (b[2] - b[0])));
					} else {
						_target[p] = b[0] + t * (2 * (1 - t) * (b[1] - b[0]) + t * (b[2] - b[0]));
					}
				}
			}
			
			if (_orient == true) {
				i = _orientData.length;
				var curVals:Object = {}, dx:Number, dy:Number, cotb:Array, toAdd:Number;
				while (i-- > 0) {
					cotb = _orientData[i]; //current orientToBezier Array
					curVals[cotb[0]] = _target[cotb[0]];
					curVals[cotb[1]] = _target[cotb[1]];
				}
				
				var oldTarget:Object = _target, oldRound:Boolean = this.round;
				_target = _future;
				this.round = false;
				_orient = false;
				i = _orientData.length;
				while (i-- > 0) {
					cotb = _orientData[i]; //current orientToBezier Array
					this.changeFactor = n + (cotb[4] || 0.01);
					toAdd = cotb[3] || 0;
					dx = _future[cotb[0]] - curVals[cotb[0]];
					dy = _future[cotb[1]] - curVals[cotb[1]];
					oldTarget[cotb[2]] = Math.atan2(dy, dx) * _RAD2DEG + toAdd;
				}
				_target = oldTarget;
				this.round = oldRound;
				_orient = true;
			}
			
			
		}
	
}