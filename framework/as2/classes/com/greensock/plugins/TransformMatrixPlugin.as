/**
 * VERSION: 1.02
 * DATE: 2010-10-11
 * ACTIONSCRIPT VERSION: 2 
 * UPDATES AND DOCUMENTATION AT: http://www.GreenSock.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;

import flash.display.*;
import flash.geom.*;
/**
 * TransformMatrixPlugin allows you to tween a MovieClip's transform.matrix values directly 
 * (<code>a, b, c, d, tx, and ty</code>) or use common properties like <code>_x, _y, _xscale, _yscale, 
 * skewX, skewY, _rotation</code> and even <code>shortRotation</code>.
 * To skew without adjusting scale visually, use skewX2 and skewY2 instead of skewX and skewY. 
 * <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.~~; <br />
 * 		TweenPlugin.activate([TransformMatrixPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {transformMatrix:{_x:50, _y:300, _xscale:200, _yscale:200}}); <br /><br />
 * 		
 * 		//-OR-<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {transformMatrix:{tx:50, ty:300, a:2, d:2}}); <br /><br />
 * 
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.TransformMatrixPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		/** @private **/
		private static var _DEG2RAD:Number = Math.PI / 180;
		
		/** @private **/
		private var _transform:Transform;
		/** @private **/
		private var _matrix:Matrix;
		/** @private **/
		private var _txStart:Number;
		/** @private **/
		private var _txChange:Number;
		/** @private **/
		private var _tyStart:Number;
		/** @private **/
		private var _tyChange:Number;
		/** @private **/
		private var _aStart:Number;
		/** @private **/
		private var _aChange:Number;
		/** @private **/
		private var _bStart:Number;
		/** @private **/
		private var _bChange:Number;
		/** @private **/
		private var _cStart:Number;
		/** @private **/
		private var _cChange:Number;
		/** @private **/
		private var _dStart:Number;
		/** @private **/
		private var _dChange:Number;
		/** @private **/
		private var _angleChange:Number;
		
		/** @private **/
		public function TransformMatrixPlugin() {
			super();
			this.propName = "transformMatrix";
			this.overwriteProps = ["_x","_y","_xscale","_yscale","_rotation","shortRotation","transformMatrix","transformAroundPoint","transformAroundCenter"];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			_transform = target.transform;
			_matrix = _transform.matrix;
			var matrix:Matrix = _matrix.clone();
			_txStart = matrix.tx;
			_tyStart = matrix.ty;
			_aStart = matrix.a;
			_bStart = matrix.b;
			_cStart = matrix.c;
			_dStart = matrix.d;
			
			if (value._x != undefined) {
				_txChange = (typeof(value._x) == "number") ? value._x - _txStart : Number(value._x);
			} else if (value.tx != undefined) {
				_txChange = value.tx - _txStart;
			} else {
				_txChange = 0;
			}
			if (value._y != undefined) {
				_tyChange = (typeof(value._y) == "number") ? value._y - _tyStart : Number(value._y);
			} else if (value.ty != undefined) {
				_tyChange = value.ty - _tyStart;
			} else {
				_tyChange = 0;
			}
			
			_aChange = (value.a != undefined) ? value.a - _aStart : 0;
			_bChange = (value.b != undefined) ? value.b - _bStart : 0;
			_cChange = (value.c != undefined) ? value.c - _cStart : 0;
			_dChange = (value.d != undefined) ? value.d - _dStart : 0;
			_angleChange = 0;
			
			if ((value._rotation != undefined) || (value.shortRotation != undefined) || (value.scale != undefined && !(value instanceof Matrix)) || (value._xscale != undefined) || (value._yscale != undefined) || (value.skewX != undefined) || (value.skewY != undefined) || (value.skewX2 != undefined) || (value.skewY2 != undefined)) {
				var ratioX:Number, ratioY:Number;
				var scaleX:Number = Math.sqrt(matrix.a * matrix.a + matrix.b * matrix.b); //Bugs in the Flex framework prevent DisplayObject.scaleX from working consistently, so we must determine it using the matrix.
				if (matrix.a < 0 && matrix.d > 0) {
					scaleX = -scaleX;
				}
				var scaleY:Number = Math.sqrt(matrix.c * matrix.c + matrix.d * matrix.d); //Bugs in the Flex framework prevent DisplayObject.scaleY from working consistently, so we must determine it using the matrix.
				if (matrix.d < 0 && matrix.a > 0) {
					scaleY = -scaleY;
				}
				var angle:Number = Math.atan2(matrix.b, matrix.a); //Bugs in the Flex framework prevent DisplayObject.rotation from working consistently, so we must determine it using the matrix
				if (matrix.a < 0 && matrix.d >= 0) {
					angle += (angle <= 0) ? Math.PI : -Math.PI;
				}
				var skewX:Number = Math.atan2(-_matrix.c, _matrix.d) - angle;
				
				var finalAngle:Number = angle;
				if (value.shortRotation != undefined) {
					var dif:Number = ((value.shortRotation * _DEG2RAD) - angle) % (Math.PI * 2);
					if (dif > Math.PI) {
						dif -= Math.PI * 2;
					} else if (dif < -Math.PI) {
						dif += Math.PI * 2;
					}
					finalAngle += dif;
				} else if (value._rotation != undefined) {
					finalAngle = (typeof(value._rotation) == "number") ? value._rotation * _DEG2RAD : Number(value._rotation) * _DEG2RAD + angle;
				}
				
				var finalSkewX:Number = (value.skewX != undefined) ? (typeof(value.skewX) == "number") ? Number(value.skewX) * _DEG2RAD : Number(value.skewX) * _DEG2RAD + skewX : 0;
				
				if (value.skewY != undefined) { //skewY is just a combonation of rotation and skewX
					var skewY:Number = (typeof(value.skewY) == "number") ? value.skewY * _DEG2RAD : Number(value.skewY) * _DEG2RAD - skewX;
					finalAngle += skewY + skewX;
					finalSkewX -= skewY;
				}
				
				if (finalAngle != angle) {
					if ((value._rotation != undefined) || (value.shortRotation != undefined)) {
						_angleChange = finalAngle - angle;
						finalAngle = angle; //to correctly affect the skewX calculations below
					} else {
						matrix.rotate(finalAngle - angle);
					}
				}
				
				if (value.scale != undefined) {
					ratioX = Number(value.scale) * 0.01 / scaleX;
					ratioY = Number(value.scale) * 0.01 / scaleY;
					if (typeof(value.scale) != "number") { //relative value
						ratioX += 1;
						ratioY += 1;
					}
				} else {
					if (value._xscale != undefined) {
						ratioX = Number(value._xscale) * 0.01 / scaleX;
						if (typeof(value._xscale) != "number") { //relative value
							ratioX += 1;
						}
					}
					if (value._yscale != undefined) {
						ratioY = Number(value._yscale) * 0.01 / scaleY;
						if (typeof(value._yscale) != "number") { //relative value
							ratioY += 1;
						}
					}
				}
				
				if (finalSkewX != skewX) {
					matrix.c = -scaleY * Math.sin(finalSkewX + finalAngle);
					matrix.d = scaleY * Math.cos(finalSkewX + finalAngle);
				}
				
				if (value.skewX2 != undefined) {
					if (typeof(value.skewX2) == "number") {
						matrix.c = Math.tan(0 - (value.skewX2 * _DEG2RAD));
					} else {
						matrix.c += Math.tan(0 - (Number(value.skewX2) * _DEG2RAD));
					}
				}
				if (value.skewY2 != undefined) {
					if (typeof(value.skewY2) == "number") {
						matrix.b = Math.tan(value.skewY2 * _DEG2RAD);
					} else {
						matrix.b += Math.tan(Number(value.skewY2) * _DEG2RAD);
					}
				}
				
				if (ratioX || ratioX == 0) { //faster than isNaN()
					matrix.a *= ratioX;
					matrix.b *= ratioX;
				}
				if (ratioY || ratioY == 0) {
					matrix.c *= ratioY;
					matrix.d *= ratioY;
				}
				_aChange = matrix.a - _aStart;
				_bChange = matrix.b - _bStart;
				_cChange = matrix.c - _cStart;
				_dChange = matrix.d - _dStart;
			}
			
			return true;
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			_matrix.a = _aStart + (n * _aChange);
			_matrix.b = _bStart + (n * _bChange);
			_matrix.c = _cStart + (n * _cChange);
			_matrix.d = _dStart + (n * _dChange);
			if (_angleChange) {
				//about 3-4 times faster than _matrix.rotate(_angleChange * n);
				var cos:Number = Math.cos(_angleChange * n);
				var sin:Number = Math.sin(_angleChange * n);
				var a:Number = _matrix.a;
				var c:Number = _matrix.c;
				_matrix.a = a * cos - _matrix.b * sin;
				_matrix.b = a * sin + _matrix.b * cos;
				_matrix.c = c * cos - _matrix.d * sin;
				_matrix.d = c * sin + _matrix.d * cos;
			}
			_matrix.tx = _txStart + (n * _txChange);
			_matrix.ty = _tyStart + (n * _tyChange);
			_transform.matrix = _matrix;
		}

}