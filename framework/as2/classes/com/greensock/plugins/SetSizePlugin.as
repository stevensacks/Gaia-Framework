/**
 * VERSION: 1.12
 * DATE: 10/2/2009
 * AS2
 * UPDATES AND DOCUMENTATION AT: http://www.TweenMax.com
 **/

import com.greensock.*;
import com.greensock.plugins.*;
/**
 * Some components require resizing with setSize() instead of standard tweens of _width/_height in
 * order to scale properly. The SetSizePlugin accommodates this easily. You can define the width, 
 * height, or both. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.SetSizePlugin; <br />
 * 		TweenPlugin.activate([SetSizePlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(myComponent, 1, {setSize:{width:200, height:30}}); <br /><br />
 * </code>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.plugins.SetSizePlugin extends TweenPlugin {
	/** @private **/
	public static var API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility	
	
	/** @private **/
	public var width:Number;
	/** @private **/
	public var height:Number;
	
	/** @private **/
	private var _target:Object;
	/** @private **/
	private var _setWidth:Boolean;
	/** @private **/
	private var _setHeight:Boolean;
	/** @private **/
	private var _hasSetSize:Boolean;
		
	/** @private **/
	public function SetSizePlugin() {
		super();
		this.propName = "setSize";
		this.overwriteProps = ["setSize","_width","_height", "_xscale", "_yscale"];
		this.round = true;
	}
	
	/** @private **/
	public function onInitTween(target:Object, value:Object, tween:TweenLite):Boolean {
		if (typeof(target) != "movieclip") { return false; }
		
		_target = target;
		_hasSetSize = Boolean(_target.setSize != undefined);
		
		if ( (value.width != undefined ) && _target._width != value.width) {
			addTween(this, "width", _target._width, value.width, "_width");
			_setWidth = _hasSetSize;
		}
		if ( (value.height != undefined ) && _target._height != value.height) {
			addTween(this, "height", _target._height, value.height, "_height");
			_setHeight = _hasSetSize;
		}			
		return true;
	}
	
	/** @private **/
	public function killProps( lookup:Object ):Void {
		super.killProps(lookup);
		if (_tweens.length == 0 || lookup.setSize != undefined ) {
			this.overwriteProps = [];
		}
	}
	
	/** @private **/
	public function set changeFactor(n:Number):Void {
		updateTweens(n);
		_target.setSize((_setWidth) ? this.width : _target._width, (_setHeight) ? this.height : _target._height);
	}
}