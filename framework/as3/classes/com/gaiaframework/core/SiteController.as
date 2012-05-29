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
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.core
{
	import com.asual.swfaddress.SWFAddress;
	import com.gaiaframework.assets.DisplayObjectAsset;
	import com.gaiaframework.assets.PageAsset;
	import com.gaiaframework.debug.GaiaDebug;
	import com.gaiaframework.events.AssetEvent;
	import com.gaiaframework.events.BranchLoaderEvent;
	import com.gaiaframework.events.GaiaEvent;
	import com.gaiaframework.events.PageEvent;
	import com.gaiaframework.flow.FlowManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;

	// This is the core class of the framework

	public class SiteController extends EventDispatcher
	{
		private static var preloadController:PreloadController;
		private static var currentBranch:String = "";
		
		private static var isTransitioning:Boolean = false;
		private static var isLoading:Boolean = false;
		
		private var transitionController:TransitionController = new TransitionController();
		private var branchLoader:BranchLoader = new BranchLoader();
		private var siteView:SiteView;
		
		private var queuedBranch:String = "";
		private var queuedFlow:String = "";
		
		public function SiteController(sv:SiteView)
		{
			super();
			siteView = sv;
			preloadController = new PreloadController();
			preloadController.addEventListener(PreloadController.READY, onPreloaderReady, false, 1);
			preloadController.addEventListener(Event.COMPLETE, onPreloadComplete);
			branchLoader.addEventListener(BranchLoaderEvent.LOAD_PAGE, onLoadPage);
			branchLoader.addEventListener(BranchLoaderEvent.LOAD_ASSET, onLoadAsset);
			branchLoader.addEventListener(BranchLoaderEvent.START, preloadController.onStart);
			branchLoader.addEventListener(AssetEvent.ASSET_PROGRESS, preloadController.onProgress);
			branchLoader.addEventListener(Event.COMPLETE, preloadController.onComplete);
			transitionController.addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			transitionController.addEventListener(PageEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
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
		public function onGoto(event:GaiaEvent):void
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
						if (event.flow == null)
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
								var i:int;
								for (i = 0; i < newArray.length; i++)
								{
									if (newArray[i] != prevArray[i]) break;
								}
								if (newArray[i] == null || newArray[i] == undefined)
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
		public function onLoadPage(event:BranchLoaderEvent):void
		{
			isLoading = true;
			var page:PageAsset = PageAsset(event.asset);
			BranchManager.addPage(page);
			siteView.addPage(page);
			page.preload();
		}
		public function onLoadAsset(event:BranchLoaderEvent):void
		{
			isLoading = true;
			if (event.asset is DisplayObjectAsset) siteView.addAsset(event.asset as DisplayObjectAsset);
			if (event.asset.preloadAsset) event.asset.preload();
		}
		
		// GAIAHQ EVENT LISTENERS
		public function onTransitionOut(event:Event):void
		{
			if (!checkQueuedBranch()) 
			{
				isTransitioning = true;
				transitionController.transitionOut(BranchManager.getTransitionOutArray(currentBranch));
			}
		}
		public function onTransitionIn(event:Event):void
		{
			if (!checkQueuedBranch()) 
			{
				isTransitioning = true;
				transitionController.transitionIn(BranchTools.getPagesOfBranch(currentBranch));
			}
		}
		public function onPreload(event:Event):void
		{
			if (!checkQueuedBranch()) 
			{
				isLoading = true;
				branchLoader.loadBranch(currentBranch);
			}
		}
		public function onComplete(event:Event):void
		{
			checkQueuedBranch();
		}
		public function onPreloadComplete(event:Event):void
		{
			isLoading = false;
			siteView.preloader.addEventListener(Event.ENTER_FRAME, preloaderEnterFrame);
		}
		
		// TRANSITION CONTROLLER EVENT LISTENERS
		private function onTransitionOutComplete(event:PageEvent):void
		{
			BranchManager.cleanup();
			FlowManager.transitionOutComplete();
		}
		private function onTransitionInComplete(event:PageEvent):void
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
		private function redirect():void
		{
			// Waiting one frame makes this more stable when spamming goto events
			siteView.addEventListener(Event.ENTER_FRAME, siteViewEnterFrame);
		}
		
		private function launchExternalPage(url:String, window:String):void
		{
			if (url.indexOf("javascript:") > -1)
			// convert javascript calls to ExternalInterface because of IE bug
			// with ExternalInterface and getURL mixing and matching
			{
				var jsCall:Array = String(url.split("javascript:")[1]).split("(");
				var method:String = String(jsCall.shift());
				var args:Array = jsCall.join("").split(")").join("").split(";").join("").split("'").join("").split(",");
				args.unshift(method);
				try
				{
					ExternalInterface.call.apply(ExternalInterface, args);
				}
				catch (e:Error)
				{
					GaiaDebug.error(method + " failed", e.name + " :: " + e.message);
				}
			}
			else
			{
				SWFAddress.href(url, window);
			}
		}
		private function onPreloaderReady(event:Event):void
		{
			preloadController.removeEventListener(Event.COMPLETE, onPreloaderReady);
			siteView.preloader.addChild(PreloadController(event.target).asset.loader);
			//siteView.preloader.addChild(DisplayObject(preloadController.clip));
		}
		// EnterFrame functions
		private function preloaderEnterFrame(event:Event):void
		{
			FlowManager.preloadComplete();
			siteView.preloader.removeEventListener(Event.ENTER_FRAME, preloaderEnterFrame);
		}
		private function siteViewEnterFrame(event:Event):void
		{
			GaiaHQ.instance.goto(queuedBranch, queuedFlow);
			siteView.removeEventListener(Event.ENTER_FRAME, siteViewEnterFrame);
		}
	}
}