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

import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.AssetLoader;
import com.gaiaframework.utils.CacheBuster;
import TextField.StyleSheet;
import mx.utils.Delegate;

class com.gaiaframework.assets.StyleSheetAsset extends AbstractAsset
{
	private var _style:StyleSheet;
	private var isSrcCss:Boolean = false;
	
	function StyleSheetAsset()
	{
		super();
	}
	public function get style():StyleSheet 
	{
		return _style;
	}
	public function init():Void
	{
		isActive = true;
		_style = new StyleSheet();
		isSrcCss = Boolean(String(src.split(".").pop()).toLowerCase() == "css");
	}
	public function preload():Void
	{
		var s:String = isSrcCss ? CacheBuster.create(src) : src;
		_style.onLoad = Delegate.create(this, onComplete);
		_style.load(s);
		super.load();
	}
	public function load():Void
	{
		AssetLoader.instance.load(this);
	}
	public function loadOnDemand():Void
	{
		preload();
	}
	public function getBytesLoaded():Number
	{
		return 0;
	}
	public function getBytesTotal():Number
	{
		return 0;
	}
	public function destroy():Void
	{
		delete _style;
		super.destroy();
	}
	public function retry():Void
	{
		var s:String = isSrcCss ? CacheBuster.create(src) : src;
		_style.load(s);
	}
	// HELPER METHOD
	public function transformStyle(styleName:String):TextFormat
	{
		return _style.transform(_style.getStyle(styleName));
	}
	// PROXY METHODS
	public function clear():Void
	{
		_style.clear();
	}
	public function getStyle(styleName:String):Object
	{
		return _style.getStyle(styleName);
	}
	public function getStyleNames():Array
	{
		return _style.getStyleNames();
	}
	public function setStyle(styleName:String, styleObject:Object):Void
	{
		_style.setStyle(styleName, styleObject);
	}
	public function transform(formatObject:Object):TextFormat
	{
		return _style.transform(formatObject);
	}
	public function toString():String
	{
		return "[StyleSheetAsset] " + _id;
	}
}