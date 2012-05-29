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

import com.gaiaframework.utils.ObservableClass;
import com.gaiaframework.assets.AssetLoader;
import com.gaiaframework.events.AssetEvent;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.core.GaiaImpl;
import mx.utils.Delegate;

class com.gaiaframework.assets.AbstractAsset extends ObservableClass
{
	private var _id:String;
	private var _src:String;
	private var _node:Object;
	public var title:String;
	public var preloadAsset:Boolean;
	public var showProgress:Boolean;
	public var bytes:Number;
	
	private var isActive:Boolean;
	private var progressInterval:Number;
	
	function AbstractAsset()
	{
		super();
	}
	public function load():Void
	{
		isActive = true;
		clearInterval(progressInterval);
		progressInterval = setInterval(Delegate.create(this, onProgress) , 30);
	}
	public function destroy():Void 
	{
		isActive = false;
		clearInterval(progressInterval);
	}
	public function get percentLoaded():Number
	{
		var t:Number = getBytesTotal();
		if (!t) return 0;
		return getBytesLoaded() / getBytesTotal();
	}
	// returns whether this asset is in the active tree 
	public function get active():Boolean
	{
		return isActive;
	}
	private function onProgress():Void
	{
		var l:Number = getBytesLoaded();
		var t:Number = getBytesTotal();
		dispatchEvent(new AssetEvent(AssetEvent.ASSET_PROGRESS, this, this, l, t, l / t));
	}
	private function onComplete():Void
	{
		clearInterval(progressInterval);
		var t:Number = getBytesTotal();
		if (bytes > 0 && t > 0 && bytes != t) bytes = t;
		dispatchEvent(new AssetEvent(AssetEvent.ASSET_COMPLETE, this, this));		
	}
	public function abort():Void
	{
		AssetLoader.instance.abort(this);
		clearInterval(progressInterval);
	}
	public function parseNode(page:PageAsset):Void
	{
		_id = _node.attributes.id;
		if (String(_node.attributes.src).indexOf("http") == 0) _src = _node.attributes.src;
		else _src = page.assetPath + _node.attributes.src;
		title = _node.attributes.title;
		preloadAsset = (_node.attributes.preload != "false");
		showProgress = (_node.attributes.progress != "false");
		bytes = Number(_node.attributes.bytes);
	}
	public function loadOnDemand():Void {}
	// stub methods for concrete classes
	public function init():Void {}
	public function preload():Void {}
	public function retry():Void {}
	public function getBytesLoaded():Number { return 0; }
	public function getBytesTotal():Number { return 0; }
	
	// Cannot overwrite id
	public function get id():String
	{
		return _id;
	}
	public function set id(value:String):Void
	{
		if (_id == undefined) _id = value;
	}
	
	// Src for Resolve Binding
	public function get src():String
	{
		return GaiaImpl.instance.resolveBinding(_src);
	}
	public function set src(value:String):Void
	{
		_src = value;
	}
	public function setSrc(value:String):Void
	{
		_src = value;
	}
	
	// Cannot overwrite node
	public function get node():Object
	{
		return _node;
	}
	public function set node(value:Object):Void
	{
		if (_node == undefined) _node = value;
	}
	
	public function toString():String
	{
		return "[Asset] " + _id;
	}
}