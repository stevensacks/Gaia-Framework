/**
 * VERSION: 2.03
 * DATE: 10/22/2009
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.core.*;
import com.greensock.plugins.*;

import flash.filters.*;
/**
 * Base class for all filter plugins (like blurFilter, colorMatrixFilter, glowFilter, etc.). Handles common routines. 
 * There is no reason to use this class directly.<br /><br />
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.FilterPlugin extends TweenPlugin {
		/** @private **/
		public static var VERSION:Number = 2.03;
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private var _target:Object;
		/** @private **/
		private var _type:Object;
		/** @private **/
		private var _filter:BitmapFilter;
		/** @private **/
		private var _index:Number;
		/** @private **/
		private var _remove:Boolean;
		
		/** @private **/
		public function FilterPlugin() {
			super();
		}
		
		/** @private **/
		private function initFilter(props:Object, defaultFilter:BitmapFilter, propNames:Array):Void {
			var filters:Array = _target.filters, p:String, i:Number, colorTween:HexColorsPlugin;
			var extras:Object = (props instanceof BitmapFilter) ? {} : props;
			_index = -1;
			if (extras.index != undefined) {
				_index = extras.index;
			} else {
				i = filters.length;
				while (i--) {
					if (filters[i] instanceof _type) {
						_index = i;
						break;
					}
				}
			}
			if (_index == -1 || filters[_index] == undefined || extras.addFilter == true) {
				_index = (extras.index != undefined) ? extras.index : filters.length;
				filters[_index] = defaultFilter;
				_target.filters = filters;
			}
			_filter = filters[_index];
			
			if (extras.remove == true) {
				_remove = true;
				this.onComplete = onCompleteTween;
			}
			i = propNames.length;
			while (i--) {
				p = propNames[i];
				if (props[p] != undefined && _filter[p] != props[p]) {
					if (p == "color" || p == "highlightColor" || p == "shadowColor") {
						colorTween = new HexColorsPlugin();
						colorTween.initColor(_filter, p, _filter[p], props[p]);
						_tweens[_tweens.length] = new PropTween(colorTween, "changeFactor", 0, 1, this.propName);
					} else if (p == "quality" || p == "inner" || p == "knockout" || p == "hideObject") {
						_filter[p] = props[p];
					} else {
						addTween(_filter, p, _filter[p], props[p], this.propName);
					}
				}
			}
		}
		
		/** @private **/
		public function onCompleteTween():Void {
			if (_remove) {
				var filters:Array = _target.filters;
				if (!(filters[_index] instanceof _type)) { //a filter may have been added or removed since the tween began, changing the index.
					var i:Number = filters.length;
					while (i--) {
						if (filters[i] instanceof _type) {
							filters.splice(i, 1);
							break;
						}
					}
				} else {
					filters.splice(_index, 1);
				}
				_target.filters = filters;
			}
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			var i:Number = _tweens.length, pt:PropTween, filters:Array = _target.filters;
			while (i--) {
				pt = _tweens[i];
				pt.target[pt.property] = pt.start + (pt.change * n);
			}
			
			if (!(filters[_index] instanceof _type)) { //a filter may have been added or removed since the tween began, changing the index.
				i = _index = filters.length; //default (in case it was removed)
				while (i--) {
					if (filters[i] instanceof _type) {
						_index = i;
						break;
					}
				}
			}
			filters[_index] = _filter;
			_target.filters = filters;
		}
	
}