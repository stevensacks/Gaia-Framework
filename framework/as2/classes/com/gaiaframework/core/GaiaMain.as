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

//Main initializes the framework.  It sets up the primary event broadcast/listener chains.

import com.gaiaframework.utils.ObservableClass;
import com.gaiaframework.assets.AssetLoader;
import com.gaiaframework.assets.AssetTypes;
import com.gaiaframework.utils.CacheBuster;
import com.gaiaframework.flow.FlowManager;
import com.gaiaframework.api.Gaia;
import com.gaiaframework.events.*;
import com.gaiaframework.debug.*;
import com.gaiaframework.core.*;
import mx.utils.Delegate;

class com.gaiaframework.core.GaiaMain extends ObservableClass
{	
	private var model:SiteModel;
	private var controller:SiteController;
	private var view:SiteView;
		
	private var clip:MovieClip;
	
	public var alignCount:Number = 0;
	public var __WIDTH:Number = 0;
	public var __HEIGHT:Number = 0;
	
	private var siteXML:String;
	
	private static var _instance:GaiaMain;
	
	function GaiaMain(target:MovieClip)
	{
		super();
		_instance = this;
		__WIDTH = Stage.width;
		__HEIGHT = Stage.height;
		GaiaDebug.isBrowser = (System.capabilities.playerType == "ActiveX" || System.capabilities.playerType == "PlugIn" || System.capabilities.playerType == "StandAlone");
		CacheBuster.isOnline = (_root._url.indexOf("http") == 0);
		clip = target.createEmptyMovieClip("site", target.getNextHighestDepth());
		AssetTypes.init();
		Gaia.api = GaiaImpl.birth();
		model = new SiteModel();
		model.addEventListener(Event.COMPLETE, Delegate.create(this, onSiteModelComplete));
		_global.setTimeout(Delegate.create(this, loadSiteXML), 1);
	}
	public static function get instance():GaiaMain
	{
		return _instance;
	}
	// override if you need to do something custom before the site xml is loaded
	private function loadSiteXML():Void
	{
		model.load(_root.siteXML || siteXML);
	}
	private function onSiteModelComplete(event:Event):Void
	{	
		view = new SiteView(clip);
		controller = new SiteController(view);
		SiteController.getPreloader().addEventListener(PreloadController.READY, Delegate.create(this, onPreloaderReady));
		GaiaHQ.birth();
		GaiaSWFAddress.birth(_root.branch);
		GaiaHQ.instance.addEventListener(GaiaEvent.GOTO, Delegate.create(controller, controller.onGoto));
		GaiaHQ.instance.addEventListener(GaiaHQ.TRANSITION_OUT, Delegate.create(controller, controller.onTransitionOut));
		GaiaHQ.instance.addEventListener(GaiaHQ.TRANSITION_IN, Delegate.create(controller, controller.onTransitionIn));
		GaiaHQ.instance.addEventListener(GaiaHQ.PRELOAD, Delegate.create(controller, controller.onPreload));
		GaiaHQ.instance.addEventListener(GaiaHQ.COMPLETE, Delegate.create(controller, controller.onComplete));
		GaiaContextMenu.init(false);
		// FOR LEGACY PURPOSES
		_global.Gaia = GaiaImpl.instance;
	}
	private function onPreloaderReady(event:Event):Void
	{
		AssetLoader.birth(PreloadController(event.target).asset);
		init();
	}
	private function initComplete():Void
	{
		if (SiteModel.indexFirst) 
		{
			GaiaHQ.instance.addListener(GaiaEvent.AFTER_COMPLETE, Delegate.create(this, initSWFAddress), false, true);
			GaiaHQ.instance.goto(SiteModel.indexID);
		}
		else
		{
			GaiaHQ.instance.addListener(GaiaEvent.AFTER_PRELOAD, Delegate.create(this, initHistory), false, true);
			GaiaContextMenu.init(SiteModel.menu);
			initSWFAddress(new Event(Event.COMPLETE));
		}
	}
	private function initSWFAddress():Void
	{
		GaiaHQ.instance.addEventListener(GaiaEvent.GOTO, Delegate.create(GaiaSWFAddress.instance, GaiaSWFAddress.instance.onGoto));
		GaiaSWFAddress.instance.addEventListener(GaiaSWFAddressEvent.GOTO, Delegate.create(GaiaHQ.instance, GaiaHQ.instance.onGoto));
		if (SiteModel.indexFirst) 
		{
			GaiaHQ.instance.addListener(GaiaEvent.AFTER_PRELOAD, Delegate.create(this, initHistory), false, true);
			GaiaContextMenu.init(SiteModel.menu);
		}
		GaiaSWFAddress.instance.init();
	}
	private function initHistory():Void
	{
		GaiaImpl.instance.setHistory(SiteModel.history);
	}
	// override for custom initialization
	private function init():Void
	{
		initComplete();
	}
	// site centering code
	public function alignSite(w:Number, h:Number):Void
	{
		__WIDTH = w;
		__HEIGHT = h;
		clip.onEnterFrame = Delegate.create(this, alignEnterFrame);
		Stage.addListener(this);
	}
	private function alignEnterFrame():Void
	{
		onResize();
		if (alignCount++ > 2) delete clip.onEnterFrame;
	}
	private function onResize():Void {}
}