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

import com.gaiaframework.debug.GaiaDebug;
import com.gaiaframework.events.GaiaSWFAddressEvent;
import com.gaiaframework.events.AssetEvent;
import com.gaiaframework.events.PageEvent;
import com.gaiaframework.assets.MovieClipAsset;
import com.gaiaframework.core.GaiaSWFAddress;
import com.gaiaframework.core.GaiaImpl;
import com.gaiaframework.api.IPage;
import mx.utils.Delegate;

class com.gaiaframework.assets.PageAsset extends MovieClipAsset
{
	private var parent:PageAsset;
	private var _children:Object;
	private var _assets:Object;
	private var _assetPath:String;
	public var external:Boolean;
	public var menu:Boolean;
	public var flow:String;
	public var defaultChild:String;
	public var route:String;
	public var window:String;
	public var landing:Boolean;
	
	private var transitionInDelegate:Function;
	private var transitionOutDelegate:Function;
	private var deeplinkDelegate:Function;
	
	private var isTransitionedIn:Boolean;
	
	function PageAsset()
	{
		super();
		isTransitionedIn = false;
		transitionInDelegate = Delegate.create(this, onTransitionInComplete);
		transitionOutDelegate = Delegate.create(this, onTransitionOutComplete);
		deeplinkDelegate = Delegate.create(this, onDeeplink);
	}
	public function getParent():PageAsset
	{
		return parent;
	}
	public function setParent(value:PageAsset):Void
	{
		if (parent == null) parent = value;
	}
	public function get branch():String
	{
		if (parent.branch != undefined) return parent.branch + "/" + _id;
		return _id;
	}
	public function get copy():Object
	{
		return assets.seo.copy;
	}
	public function transitionIn():Void
	{
		if (!isTransitionedIn && IPage(content) != undefined && IPage(content) != null) 
		{
			IPage(_content).transitionIn();
		}
		else
		{
			onTransitionInComplete();
		}
	}
	public function transitionOut():Void
	{
		GaiaSWFAddress.instance.removeEventListener(GaiaSWFAddressEvent.DEEPLINK, deeplinkDelegate);
		if (isTransitionedIn && IPage(content) != undefined && IPage(content) != null) 
		{
			IPage(content).transitionOut();
		}
		else
		{
			onTransitionOutComplete();
		}
	}
	public function destroy():Void
	{
		isTransitionedIn = false;
		_content.removeEventListener(PageEvent.TRANSITION_IN_COMPLETE, transitionInDelegate);
		_content.removeEventListener(PageEvent.TRANSITION_OUT_COMPLETE, transitionOutDelegate);
		GaiaSWFAddress.instance.removeEventListener(GaiaSWFAddressEvent.DEEPLINK, deeplinkDelegate);
		for (var a:String in assets)
		{
			assets[a].abort();
			assets[a].destroy();
		}
		super.destroy();
	}
	private function decorate():Void
	{
		_content.addEventListener(PageEvent.TRANSITION_IN_COMPLETE, transitionInDelegate);
		_content.addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, transitionOutDelegate);
		_content.page = this;
	}
	// EVENT LISTENERS
	private function onTransitionInComplete():Void
	{
		isTransitionedIn = true;
		dispatchEvent(new PageEvent(PageEvent.TRANSITION_IN_COMPLETE, this));
	}
	private function onTransitionOutComplete():Void
	{
		destroy();
		dispatchEvent(new PageEvent(PageEvent.TRANSITION_OUT_COMPLETE, this));
	}
	// decorate and make visible (MovieClipAsset default is false)
	private function onComplete():Void
	{
		decorate();
		GaiaSWFAddress.instance.addEventListener(GaiaSWFAddressEvent.DEEPLINK, deeplinkDelegate);
		isTransitionedIn = false;
		super.onComplete();
		_content._visible = true;
	}
	// GaiaSWFAddress sends deeplink events to active pages
	private function onDeeplink(event:GaiaSWFAddressEvent):Void
	{
		IPage(_content).onDeeplink(event);
	}
	// Prevent overwriting
	public function get children():Object
	{
		return _children;
	}
	public function set children(value:Object):Void
	{
		if (_children == null) _children = value;
	}
	public function get assets():Object
	{
		return _assets;
	}
	public function set assets(value:Object):Void
	{
		if (_assets == null) _assets = value;
	}
	// Enable Binding
	public function get assetPath():String
	{
		return GaiaImpl.instance.resolveBinding(_assetPath);
	}
	public function set assetPath(value:String):Void
	{
		_assetPath = value;
	}
}