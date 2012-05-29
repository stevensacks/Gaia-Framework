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
import com.gaiaframework.flow.FlowManager;
import com.gaiaframework.events.*;
import com.gaiaframework.assets.*;
import com.gaiaframework.core.*;
import com.gaiaframework.api.*
import com.asual.swfaddress.SWFAddress;
import flash.external.ExternalInterface;
import mx.utils.Delegate;

// This is the core class of the framework.  

class com.gaiaframework.core.SiteController extends ObservableClass
{	
	private static var preloadController:PreloadController;	
	private static var currentBranch:String = "";
	
	private static var isTransitioning:Boolean = false;
	private static var isLoading:Boolean = false;
	
	private var transitionController:TransitionController;
	private var branchLoader:BranchLoader;
	private var siteView:SiteView;
	
	private var queuedBranch:String = "";
	private var queuedFlow:String = "";
	
	function SiteController(sv:SiteView)
	{
		super();
		siteView = sv;
		transitionController = new TransitionController()
		branchLoader = new BranchLoader();
		preloadController = new PreloadController();
		preloadController.addEventListener(Event.COMPLETE, Delegate.create(this, onPreloadComplete));
		branchLoader.addEventListener(BranchLoaderEvent.LOAD_PAGE, Delegate.create(this, onLoadPage));
		branchLoader.addEventListener(BranchLoaderEvent.LOAD_ASSET, Delegate.create(this, onLoadAsset));
		branchLoader.addEventListener(BranchLoaderEvent.START, Delegate.create(preloadController, preloadController.onStart));
		branchLoader.addEventListener(AssetEvent.ASSET_PROGRESS, Delegate.create(preloadController, preloadController.onProgress));
		branchLoader.addEventListener(Event.COMPLETE, Delegate.create(preloadController, preloadController.onComplete));
		transitionController.addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, Delegate.create(this, onTransitionOutComplete));
		transitionController.addEventListener(PageEvent.TRANSITION_IN_COMPLETE, Delegate.create(this, onTransitionInComplete));
	}
	public static function getCurrentBranch():String
	{
		return currentBranch;
	}
	public static function getPreloader():PreloadController
	{
		return preloadController;
	}
	public static function get busy():Boolean
	{
		return isTransitioning || isLoading;
	}
	// GAIAHQ RECEIVER
	public function onGoto(event:GaiaEvent):Void
	{
		BranchManager.cleanup();
		var validBranch:String = event.validBranch;
		if (!event.external)
		{
			if (validBranch != currentBranch)
			{
				if (!isTransitioning && !isLoading) 
				{
					queuedBranch = "";
					queuedFlow = "";
					var flow:String;
					if (event.flow == undefined || event.flow == null)
					{
						if (!SiteModel.tree.active && SiteModel.indexFirst)
						{
							// first just load the index
							currentBranch = SiteModel.indexID;
							flow = SiteModel.tree.flow;
						}
						else
						{
							// need to get the branch root page that will transition in to determine flow
							var prevArray:Array = BranchTools.getPagesOfBranch(currentBranch);
							var newArray:Array = BranchTools.getPagesOfBranch(validBranch);
							var i:Number;
							for (i = 0; i < newArray.length; i++)
							{
								if (newArray[i] != prevArray[i]) break;
							}
							if (newArray[i] == undefined)
							{
								flow = SiteModel.defaultFlow;
							}
							else
							{
								flow = PageAsset(newArray[i]).flow;
							}
							currentBranch = validBranch;
						}
					}
					else
					{
						flow = event.flow;
						currentBranch = validBranch;
					}	
					FlowManager.init(flow);
					FlowManager.start();
				}
				else 
				{
					queuedBranch = event.fullBranch;	
					queuedFlow = event.flow;
					if (!isLoading) 
					{
						transitionController.interrupt();
					}
					else
					{
						branchLoader.interrupt();
					}
				}
			}
		}
		else
		{
			launchExternalPage(event.src, event.window);
		}
	}
	
	// BRANCH LOADER EVENT LISTENERS
	public function onLoadPage(event:BranchLoaderEvent):Void
	{
		isLoading = true;
		var page:PageAsset = PageAsset(event.asset);
		BranchManager.addPage(page);
		siteView.addPage(page);
		page.preload();
	}
	public function onLoadAsset(event:BranchLoaderEvent):Void
	{
		isLoading = true;
		var asset:AbstractAsset = event.asset;
		if (!(asset instanceof XMLAsset) && !(asset instanceof NetStreamAsset)) siteView.addAsset(asset);
		if (event.asset.preloadAsset) event.asset.preload();
	}	
	// GAIAHQ EVENT LISTENERS
	public function onTransitionOut(event:Event):Void
	{
		if (!checkQueuedBranch()) 
		{
			isTransitioning = true;
			transitionController.transitionOut(BranchManager.getTransitionOutArray(currentBranch));
		}
	}
	public function onTransitionIn(event:Event):Void
	{
		if (!checkQueuedBranch()) 
		{
			isTransitioning = true;
			transitionController.transitionIn(BranchTools.getPagesOfBranch(currentBranch));
		}
	}
	public function onPreload(event:Event):Void
	{
		if (!checkQueuedBranch()) 
		{
			isLoading = true;
			branchLoader.loadBranch(currentBranch);
		}
	}
	public function onComplete(event:Event):Void
	{
		checkQueuedBranch();
	}
	
	// PRELOAD COMPLETE EVENT RECEIVER FROM EVENT HQ
	public function onPreloadComplete(event:Event):Void
	{
		isLoading = false;
		if (!SiteView.preloader.onEnterFrame) SiteView.preloader.onEnterFrame = Delegate.create(this, preloaderEnterFrame);
	}
	
	// TRANSITION CONTROLLER EVENT LISTENERS
	private function onTransitionOutComplete(event:PageEvent):Void
	{
		BranchManager.cleanup();
		FlowManager.transitionOutComplete();
	}
	private function onTransitionInComplete(event:PageEvent):Void
	{
		BranchManager.cleanup();
		FlowManager.transitionInComplete();
	}
	
	// UTILITY FUNCTIONS
	private function checkQueuedBranch():Boolean
	{
		isLoading = isTransitioning = false;
		if (queuedBranch.length > 0)
		{
			redirect();
			return true;
		}
		return false;
	}
	private function redirect():Void
	{
		// Waiting one frame makes this more stable when spamming goto events
		siteView.clip.onEnterFrame = Delegate.create(this, siteViewEnterFrame);
	}
	private function launchExternalPage(url:String, window:String):Void
	{
		if (url.indexOf("javascript:") > -1)
		// convert javascript calls to ExternalInterface because of IE bug
		// with ExternalInterface and getURL mixing and matching
		{
			var jsCall:Array = String(url.split("javascript:")[1]).split("(");
			var method:String = String(jsCall.shift());
			var args:Array = jsCall.join("").split(")").join("").split(";").join("").split("'").join("").split(",");
			args.unshift(method);
			ExternalInterface.call.apply(ExternalInterface, args);
		}
		else
		{
			SWFAddress.href(url, window);
		}
	}
	// EnterFrame functions
	private function preloaderEnterFrame():Void
	{
		FlowManager.preloadComplete();
		delete SiteView.preloader.onEnterFrame;
	}
	private function siteViewEnterFrame():Void
	{
		GaiaHQ.instance.goto(queuedBranch, queuedFlow);
		delete siteView.clip.onEnterFrame;
	}
}