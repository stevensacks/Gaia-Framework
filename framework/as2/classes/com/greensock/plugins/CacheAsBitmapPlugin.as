/**
 * VERSION: 0.9
 * DATE: 2010-07-28
 * ACTIONSCRIPT VERSION: 2.0
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/
import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Forces the <code>cacheAsBitmap</code> property of a MovieClip to be a certain value (<code>true</code> or <code>false</code>)
 * during the tween and then sets it back to whatever it was before the tween was rendered for the first time. This <i>can</i> improve 
 * performance in certain situations, like when the MovieClip <strong>NOT</strong> tweening its rotation, scaleX, scaleY, or similar
 * things with its <code>transform.matrix</code>. See Adobe's docs for details about when it is appropriate to set <code>cacheAsBitmap</code>
 * to <code>true</code>. Also beware that whenever a MovieClip's <code>cacheAsBitmap</code> is <code>true</code>, it will ONLY be
 * rendered on whole pixel values which can lead to animation that looks "choppy" at slow speeds.<br /><br /> 
 * 
 * For example, if you want to set <code>cacheAsBitmap</code> to <code>true</code> while the tween is running, do:<br /><br /><code>
 * 
 * TweenLite.to(mc, 1, {_x:100, cacheAsBitmap:true});<br /><br /></code>
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.CacheAsBitmapPlugin; <br />
 * 		TweenPlugin.activate([CacheAsBitmapPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {_x:100, cacheAsBitmap:true}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.CacheAsBitmapPlugin extends TweenPlugin {
		/** @private **/
		public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		private var _target:MovieClip;
		/** @private **/
		private var _tween:TweenLite;
		/** @private **/
		private var _cacheAsBitmap:Boolean;
		/** @private **/
		private var _initVal:Boolean;
		
		/** @private **/
		public function CacheAsBitmapPlugin() {
			super();
			this.propName = "cacheAsBitmap";
			this.overwriteProps = ["cacheAsBitmap"];
		}
		
		/** @private **/
		public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
			_target = MovieClip(target);
			_tween = tween;
			_initVal = _target.cacheAsBitmap;
			_cacheAsBitmap = Boolean(value);
			return true;
		}
		
		/** @private **/
		public function set changeFactor(n:Number):Void {
			if (_tween.cachedDuration == _tween.cachedTime || _tween.cachedTime == 0) { //a changeFactor of 1 doesn't necessarily mean the tween is done - if the ease is Elastic.easeOut or Back.easeOut for example, they could hit 1 mid-tween. 
				_target.cacheAsBitmap = _initVal;
			} else if (_target.cacheAsBitmap != _cacheAsBitmap) {
				_target.cacheAsBitmap = _cacheAsBitmap;
			}
		}

}