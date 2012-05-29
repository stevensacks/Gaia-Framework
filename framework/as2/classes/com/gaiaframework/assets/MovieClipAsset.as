/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* git: https://github.com/stevensacks/Gaia-Framework
* support: http://gaiaflashframework.tenderapp.com/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license 
*****************************************************************************************************/

import com.gaiaframework.api.Gaia;
import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.AssetLoader;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.utils.CacheBuster;
import mx.utils.Delegate;

class com.gaiaframework.assets.MovieClipAsset extends AbstractAsset
{
	public var depth:String;
	private var _content:MovieClip;
	
	function MovieClipAsset()
	{
		super();
		_content = null;
	}
	public function set content(value:MovieClip):Void
	{
		if (_content == null) _content = value;
	}
	public function get content():MovieClip
	{
		return _content;
	}
	public function init():Void
	{
		isActive = true;
	}
	public function preload():Void
	{
		_content.loadMovie(src);
		super.load();
	}
	public function load():Void
	{
		AssetLoader.instance.load(this);
	}
	public function loadOnDemand():Void
	{
		_content.loadMovie(CacheBuster.version(src));
		super.load();
	}
	public function getBytesLoaded():Number
	{
		return _content.getBytesLoaded() || 0;
	}
	public function getBytesTotal():Number
	{
		return _content.getBytesTotal() || 0;
	}
	public function destroy():Void
	{
		_content.removeMovieClip();
		_content = null;
		super.destroy();
	}
	public function onProgress():Void
	{
		super.onProgress();
		if (_content.getBytesLoaded() == _content.getBytesTotal() && _content.getBytesTotal() > 4) 
		{
			clearInterval(progressInterval);
			progressInterval = setInterval(Delegate.create(this, onComplete), 75);
		}
	}
	public function onComplete():Void
	{
		_content._visible = false;
		_content._x = _content._y = 0;
		super.onComplete();
	}
	public function retry():Void
	{
		_content.loadMovie(src);
	}
	public function parseNode(page:PageAsset):Void 
	{
		super.parseNode(page);
		var d:String = String(_node.attributes.depth).toLowerCase();
		if (d == Gaia.TOP || d == Gaia.BOTTOM || d == Gaia.MIDDLE || d == Gaia.PRELOADER) depth = d;
		else depth = page.depth;
	}
	
	// PROXY MOVIECLIP PROPS/FUNCS
	public function get _alpha():Number
	{
		return _content._alpha;
	}
	public function set _alpha(value:Number):Void
	{
		_content._alpha = value;
	}
	public function get blendMode():Object
	{
		return _content.blendMode;
	}
	public function set blendMode(value:Object):Void
	{
		_content.blendMode = value;
	}
	public function get cacheAsBitmap():Boolean
	{
		return _content.cacheAsBitmap;
	}
	public function set cacheAsBitmap(value:Boolean):Void
	{
		_content.cacheAsBitmap = value;
	}
	public function get _currentframe():Number
	{
		return _content._currentframe;
	}
	public function get filters():Array
	{
		return _content.filters;
	}
	public function set filters(value:Array):Void
	{
		_content.filters = value;
	}
	public function get enabled():Boolean
	{
		return _content.enabled;
	}
	public function set enabled(value:Boolean):Void
	{
		_content.enabled = value;
	}
	public function get _height():Number
	{
		return _content._height;
	}
	public function set _height(value:Number):Void
	{
		_content._height = value;
	}
	public function get _name():String
	{
		return _content._name;
	}
	public function set _name(value:String):Void
	{
		_content._name = value;
	}
	public function get _parent():MovieClip
	{
		return _content._parent;
	}
	public function get _rotation():Number
	{
		return _content._rotation;
	}
	public function set _rotation(value:Number):Void
	{
		_content._rotation = value;
	}
	public function get tabEnabled():Boolean
	{
		return _content.tabEnabled;
	}
	public function set tabEnabled(value:Boolean):Void
	{
		_content.tabEnabled = value;
	}
	public function get tabIndex():Number
	{
		return _content.tabIndex;
	}
	public function set tabIndex(value:Number):Void
	{
		_content.tabIndex = value;
	}
	public function get _totalframes():Number
	{
		return _content._totalframes;;
	}
	public function get useHandCursor():Boolean
	{
		return _content.useHandCursor;
	}
	public function set useHandCursor(value:Boolean):Void
	{
		_content.useHandCursor = value;
	}
	public function get _visible():Boolean
	{
		return _content._visible;
	}
	public function set _visible(value:Boolean):Void
	{
		_content._visible = value;
	}
	public function get _width():Number
	{
		return _content._width;
	}
	public function set _width(value:Number):Void
	{
		_content._width = value;
	}
	public function get _x():Number
	{
		return _content._x;
	}
	public function set _x(value:Number):Void
	{
		_content._x = value;
	}
	public function get _y():Number
	{
		return _content._y;
	}
	public function set _y(value:Number):Void
	{
		_content._y = value;
	}
	public function get _xscale():Number
	{
		return _content._xscale;
	}
	public function set _xscale(value:Number):Void
	{
		_content._xscale = value;
	}
	public function get _yscale():Number
	{
		return _content._yscale;
	}
	public function set _yscale(value:Number):Void
	{
		_content._yscale = value;
	}
	public function get _xmouse():Number
	{
		return _content._xmouse;
	}
	public function get _ymouse():Number
	{
		return _content._ymouse;
	}
	
	// PROXY FUNCTIONS
	public function setMask(value:MovieClip):Void
	{
		_content.setMask(value);
	}
	public function gotoAndPlay(value:Object):Void
	{
		_content.gotoAndPlay(value);
	}
	public function gotoAndStop(value:Object):Void
	{
		_content.gotoAndStop(value);
	}
	public function nextFrame():Void
	{
		_content.nextFrame();
	}
	public function prevFrame():Void
	{
		_content.prevFrame();
	}
	public function play():Void
	{
		_content.play();
	}
	public function stop():Void
	{
		_content.stop();
	}
	public function startDrag(lockCenter:Boolean, left:Number, top:Number, right:Number, bottom:Number):Void
	{
		_content.startDrag(lockCenter, left, top, right, bottom);
	}
	public function stopDrag():Void
	{
		_content.stopDrag();
	}
	
	// ON METHODS
	public function set onPress(value:Function):Void
	{
		_content.onPress = value;
	}
	public function set onRelease(value:Function):Void
	{
		_content.onRelease = value;
	}
	public function set onReleaseOutside(value:Function):Void
	{
		_content.onReleaseOutside = value;
	}
	public function set onRollOut(value:Function):Void
	{
		_content.onRollOut = value;
	}
	public function set onRollOver(value:Function):Void
	{
		_content.onRollOver = value;
	}
	public function set onDragOver(value:Function):Void
	{
		_content.onDragOver = value;
	}
	public function set onDragOut(value:Function):Void
	{
		_content.onDragOut = value;
	}
	public function set onEnterFrame(value:Function):Void
	{
		_content.onEnterFrame = value;
	}
	public function set onKeyUp(value:Function):Void
	{
		_content.onKeyUp = value;
	}
	public function set onKeyDown(value:Function):Void
	{
		_content.onKeyDown = value;
	}
	public function get onPress():Function
	{
		return _content.onPress;
	}
	public function get onRelease():Function
	{
		return _content.onRelease;
	}
	public function get onReleaseOutside():Function
	{
		return _content.onReleaseOutside;
	}
	public function get onRollOut():Function
	{
		return _content.onRollOut;
	}
	public function get onRollOver():Function
	{
		return _content.onRollOver;
	}
	public function get onDragOver():Function
	{
		return _content.onDragOver;
	}
	public function get onDragOut():Function
	{
		return _content.onDragOut;
	}
	public function get onEnterFrame():Function
	{
		return _content.onEnterFrame;
	}
	public function get onKeyUp():Function
	{
		return _content.onKeyUp;
	}
	public function get onKeyDown():Function
	{
		return _content.onKeyDown;
	}
	public function toString():String
	{
		return "[MovieClipAsset] " + _id;
	}
}