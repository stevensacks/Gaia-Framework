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

//Main initializes the framework.  It sets up the primary event broadcast/listener chains.

package com.gaiaframework.core
{
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.assets.AssetLoader;
	import com.gaiaframework.assets.AssetTypes;
	import com.gaiaframework.events.GaiaEvent;
	import com.gaiaframework.events.GaiaSWFAddressEvent;
	import com.gaiaframework.utils.CacheBuster;

	import flash.display.Sprite;
	import flash.events.Event;

	public class GaiaMain extends Sprite
	{
		protected var model:SiteModel;
		protected var controller:SiteController;
		protected var view:SiteView;
		
		public var alignCount:int = 0;
		public var __WIDTH:int = 0;
		public var __HEIGHT:int = 0;
		
		protected var siteXML:String;
		
		protected static var _instance:GaiaMain;
		
		public function GaiaMain()
		{
			super();
			_instance = this;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		public static function get instance():GaiaMain
		{
			return _instance;
		}
		protected function onAddedToStage(event:Event):void
		{
			//SWFWheel.initialize(stage);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (stage.stageWidth == 0 || stage.stageHeight == 0) addEventListener(Event.ENTER_FRAME, onWaitForWidthAndHeight);
			else startGaia();
		}
		private function onWaitForWidthAndHeight(event:Event):void
		{
			if (stage.stageWidth > 0 && stage.stageHeight > 0)
			{
				removeEventListener(Event.ENTER_FRAME, onWaitForWidthAndHeight);
				startGaia();
			}
		}
		private function startGaia():void
		{
			if (!__WIDTH) __WIDTH = stage.stageWidth;
			if (!__HEIGHT) __HEIGHT = stage.stageHeight;
			CacheBuster.isOnline = (stage.loaderInfo.url.indexOf("http") == 0);
			use namespace gaia_internal;
			AssetTypes.init();
			Gaia.impl = GaiaImpl.birth();
			model = new SiteModel(stage.loaderInfo.url);
			model.addEventListener(Event.COMPLETE, onSiteModelComplete);
			view = new SiteView();
			loadSiteXML();
		}
		// override if you need to do something custom before the site xml is loaded
		protected function loadSiteXML():void
		{
			model.load(stage.loaderInfo.parameters.siteXML || siteXML);
		}
		private function onSiteModelComplete(event:Event):void
		{	
			addChild(view);
			controller = new SiteController(view);
			SiteController.getPreloader().addEventListener(PreloadController.READY, onPreloaderReady);
			GaiaHQ.birth();
			GaiaSWFAddress.birth(stage.loaderInfo.parameters.branch);
			GaiaHQ.instance.addEventListener(GaiaEvent.GOTO, controller.onGoto);
			GaiaHQ.instance.addEventListener(GaiaHQ.TRANSITION_OUT, controller.onTransitionOut);
			GaiaHQ.instance.addEventListener(GaiaHQ.TRANSITION_IN, controller.onTransitionIn);
			GaiaHQ.instance.addEventListener(GaiaHQ.PRELOAD, controller.onPreload);
			GaiaHQ.instance.addEventListener(GaiaHQ.COMPLETE, controller.onComplete);
			contextMenu = GaiaContextMenu.init(false);
		}
		private function onPreloaderReady(event:Event):void
		{
			AssetLoader.birth(PreloadController(event.target).asset);
			init();
		}
		protected function initComplete():void
		{
			if (SiteModel.indexFirst) 
			{
				GaiaHQ.instance.addListener(GaiaEvent.AFTER_COMPLETE, initSWFAddress, false, true);
				GaiaHQ.instance.goto(SiteModel.indexID);
			}
			else
			{
				GaiaHQ.instance.addListener(GaiaEvent.AFTER_PRELOAD, initHistory, false, true);
				contextMenu = GaiaContextMenu.init(SiteModel.menu);
				initSWFAddress(new Event(Event.COMPLETE));
			}
		}
		private function initSWFAddress(event:Event):void
		{
			GaiaHQ.instance.addEventListener(GaiaEvent.GOTO, GaiaSWFAddress.instance.onGoto);
			GaiaSWFAddress.instance.addEventListener(GaiaSWFAddressEvent.GOTO, GaiaHQ.instance.onGoto);
			if (SiteModel.indexFirst)
			{
				GaiaHQ.instance.addListener(GaiaEvent.AFTER_PRELOAD, initHistory, false, true);
				contextMenu = GaiaContextMenu.init(SiteModel.menu);
			}
			GaiaSWFAddress.instance.init();
		}
		private function initHistory(event:Event):void
		{
			GaiaImpl.instance.setHistory(SiteModel.history);
		}
		// override for custom initialization
		protected function init():void
		{
			initComplete();
		}
		// site centering code
		protected function alignSite(w:int, h:int):void
		{
			__WIDTH = w;
			__HEIGHT = h;
			stage.addEventListener(Event.RESIZE, onResize);
			addEventListener(Event.ENTER_FRAME, alignEnterFrame, false, 0, true);
		}
		protected function alignEnterFrame(event:Event):void
		{
			if (view)
			{
				onResize(new Event(Event.RESIZE));
				if (alignCount++ > 2) removeEventListener(Event.ENTER_FRAME, alignEnterFrame);
			}
		}
		protected function onResize(event:Event):void {}
	}
}