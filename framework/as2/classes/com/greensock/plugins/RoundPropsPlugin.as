/**
 * VERSION: 2.01
 * DATE: 2010-12-24
 * AS2
 * UPDATES AND DOCS AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
import com.greensock.core.PropTween;
/**
 * If you'd like the inbetween values in a tween to always get rounded to the nearest integer, use the roundProps
 * special property. Just pass in an Array containing the property names that you'd like rounded. For example,
 * if you're tweening the _x, _y, and _alpha properties of mc and you want to round the _x and _y values (not _alpha)
 * every time the tween is rendered, you'd do: <br /><br /><code>
 * 	
 * 	TweenMax.to(mc, 2, {_x:300, _y:200, _alpha:50, roundProps:["_x","_y"]});<br /><br /></code>
 * 
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenMax; <br /> 
 * 		import com.greensock.plugins.RoundPropsPlugin; <br />
 * 		TweenPlugin.activate([RoundPropsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 2, {_x:300, _y:200, _alpha:50, roundProps:["_x","_y"]}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.RoundPropsPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private var _tween:TweenLite;
		
		/** @private **/
		public function RoundPropsPlugin() {
			super();
			this.propName = "roundProps";
			this.overwriteProps = ["roundProps"];
			this.round = true;
			this.priority = -1;
			this.onInitAllProps = _initAllProps;
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			_tween = tween;
			var a = value; // to get around strict data typing errors
			this.overwriteProps = this.overwriteProps.concat(a);
			return true;
		}
		
		/** @private **/
		private function _initAllProps():Void {
			var prop:String, multiProps:String, rp:Array = _tween.vars.roundProps, pt:PropTween;
			var i:Number = rp.length;
			while (--i > -1) {
				prop = rp[i];
				pt = _tween.cachedPT1;
				while (pt) {
					if (pt.name == prop) {
						if (pt.isPlugin) {
							pt.target.round = true;
						} else {
							add(pt.target, prop, pt.start, pt.change);
							_removePropTween(pt);
							_tween.propTweenLookup[prop] = _tween.propTweenLookup.roundProps;
						}
					} else if (pt.isPlugin && pt.name == "_MULTIPLE_" && !pt.target.round) {
						multiProps = " " + pt.target.overwriteProps.join(" ") + " ";
						if (multiProps.indexOf(" " + prop + " ") != -1) {
							pt.target.round = true;
						}
					}
					pt = pt.nextNode;
				}
			}
		}
		
		/** @private **/
		private function _removePropTween(propTween:PropTween):Void {
			if (propTween.nextNode) {
				propTween.nextNode.prevNode = propTween.prevNode;
			}
			if (propTween.prevNode) {
				propTween.prevNode.nextNode = propTween.nextNode;
			} else if (_tween.cachedPT1 == propTween) {
				_tween.cachedPT1 = propTween.nextNode;
			}
			if (propTween.isPlugin && propTween.target.onDisable) {
				propTween.target.onDisable(); //some plugins need to be notified so they can perform cleanup tasks first
			}
		}
		
		/** @private **/
		public function add(object:Object, propName:String, start:Number, change:Number):Void {
			addTween(object, propName, start, start + change, propName);
			this.overwriteProps[this.overwriteProps.length] = propName;
		}
	
}