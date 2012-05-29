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
import com.gaiaframework.events.*;
import com.gaiaframework.assets.*;
import com.gaiaframework.utils.*;
import com.gaiaframework.core.*;
import com.gaiaframework.api.*;

import com.asual.swfaddress.SWFAddress;
import mx.utils.Delegate;

class com.gaiaframework.core.GaiaImpl implements IGaia
{
	private static var _instance:GaiaImpl;
	
	public function GaiaImpl()
	{
		GaiaDebug.log("Gaia Framework (AS2) v3.3.0");
	}
	public static function birth():IGaia
	{
		if (_instance == null) return _instance = new GaiaImpl();
		return _instance;
	}
	public static function get instance():GaiaImpl
	{
		return _instance;
	}
	public function goto(branch:String, flow:String):Void
	{
		GaiaHQ.instance.goto(branch, flow);
	}
	public function gotoRoute(route:String, deeplink:String, flow:String):Void
	{
		var validRoute:String = SiteModel.routes[route];
		if (validRoute) validRoute += (deeplink || "");
		GaiaHQ.instance.goto(validRoute || "index", flow);
	}
	public function getSiteTree():PageAsset
	{
		return SiteModel.tree;
	}
	public function getMenuArray():Array
	{
		return SiteModel.menuArray;
	}
	public function getSiteTitle():String
	{
		return SiteModel.title;
	}
	public function setSiteTitle(value:String):Void
	{
		SiteModel.title = value;
		if (value.length > 0) setTitle(value.split("%PAGE%").join(BranchTools.getPage(getCurrentBranch()).title));
	}
	public function setDelimiter(value:String):Void
	{
		SiteModel.delimiter = value;
	}
	public function getSiteXML():XML
	{
		return SiteModel.xml;
	}
	public function getPage(branch:String):PageAsset
	{
		return BranchTools.getPage(branch);
	}
	public function getDepthContainer(name:String):MovieClip
	{
		return SiteView.getDepthContainer(name.toLowerCase());
	}
	public function getValidBranch(branch:String):String
	{
		return BranchTools.getValidBranch(branch);
	}
	public function getCurrentBranch():String
	{
		return SiteController.getCurrentBranch();
	}
	public function getPreloader():MovieClipAsset
	{
		return SiteController.getPreloader().asset;
	}
	public function setPreloader(asset:MovieClipAsset):Void
	{
		SiteController.getPreloader().asset = asset;
	}
	public function getAssetPreloader():MovieClipAsset
	{
		return AssetLoader.instance.asset;
	}
	public function setAssetPreloader(asset:MovieClipAsset):Void
	{
		AssetLoader.instance.asset = asset;
	}
	public function getDeeplink():String
	{
		return GaiaSWFAddress.deeplink;
	}
	public function getDefaultFlow():String
	{
		return SiteModel.defaultFlow;
	}
	public function setDefaultFlow(flow:String):Void
	{
		SiteModel.defaultFlow = flow;
	}
	public function addAssets(nodes:Array, page:PageAsset):Void
	{
		AssetCreator.add(nodes, page);
	}
	public function refreshContextMenu():Void
	{
		GaiaContextMenu.init(SiteModel.menu);
	}
	public function getWidth():Number
	{
		return GaiaMain.instance.__WIDTH;
	}
	public function getHeight():Number
	{
		return GaiaMain.instance.__HEIGHT;
	}
	public function getSitePosition():Object
	{
		return {x:SiteView.instance.clip._x, y:SiteView.instance.clip._y};
	}
	public function setLoadTimeout(value:Number):Void
	{
		BranchLoader.timeoutLength = value;
	}
	public function setPreloaderDelay(value:Number):Void
	{
		PreloadController.delay = value;
	}
	public function setGlobalVolume(value:Number, duration:Number, onComplete:Function):Void
	{
		if (isNaN(duration)) SoundUtils.volume = value;
		else SoundUtils.fadeTo(SoundUtils, value, duration, onComplete);
	}
	public function getGlobalVolume():Number
	{
		return SoundUtils.volume;
	}
	public function addCustomAsset(assetClass:Function, type:String):Void
	{
		AssetTypes.add(assetClass, type);
	}
	public function getBusy():Boolean
	{
		return SiteController.busy;
	}
	// SWFAddress Proxy
	public function back():Void
	{
		SWFAddress.back();
	}
	public function forward():Void
	{
		SWFAddress.forward();
	}
	public function getTitle():String
	{
		return SWFAddress.getTitle();
	}
	public function setTitle(title:String):Void
	{
		SWFAddress.setTitle(title);
	}
	public function href(url:String, target:String):Void
	{
		SWFAddress.href(url, target);
	}
	public function popup(url:String, name:String, options:String, handler:String):Void
	{
		SWFAddress.popup(url, name, options, handler);
	}
	public function getValue():String
	{
		return GaiaSWFAddress.getValue();
	}
	public function setHistory(value:Boolean):Void
	{
		SWFAddress.setHistory(value);
	}
	public function getHistory():Boolean
	{
		return SWFAddress.getHistory();
	}
	public function setTracker(value:String):Void
	{
		SWFAddress.setTracker(value);
	}
	public function getTracker():String
	{
		return SWFAddress.getTracker();
	}
	public function getBaseURL():String
	{
		return SWFAddress.getBaseURL();
	}

	// Hijack Events
	public function beforeGoto(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return GaiaHQ.instance.addListener(GaiaEvent.BEFORE_GOTO, target, hijack, onlyOnce);
	}
	public function afterGoto(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return GaiaHQ.instance.addListener(GaiaEvent.AFTER_GOTO, target, hijack, onlyOnce);
	}
	
	public function beforeTransitionOut(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return GaiaHQ.instance.addListener(GaiaEvent.BEFORE_TRANSITION_OUT, target, hijack, onlyOnce);
	}
	public function afterTransitionOut(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return GaiaHQ.instance.addListener(GaiaEvent.AFTER_TRANSITION_OUT, target, hijack, onlyOnce);
	}
	
	public function beforePreload(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return GaiaHQ.instance.addListener(GaiaEvent.BEFORE_PRELOAD, target, hijack, onlyOnce);
	}
	public function afterPreload(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return GaiaHQ.instance.addListener(GaiaEvent.AFTER_PRELOAD, target, hijack, onlyOnce);
	}
	
	public function beforeTransitionIn(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return GaiaHQ.instance.addListener(GaiaEvent.BEFORE_TRANSITION_IN, target, hijack, onlyOnce);
	}
	public function afterTransitionIn(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return GaiaHQ.instance.addListener(GaiaEvent.AFTER_TRANSITION_IN, target, hijack, onlyOnce);
	}
	
	public function afterComplete(target:Function, onlyOnce:Boolean):Function
	{
		return GaiaHQ.instance.addListener(GaiaEvent.AFTER_COMPLETE, target, false, onlyOnce);
	}
	
	// Remove Hijack Events (just in case you need to manually)
	public function removeBeforeGoto(target:Function):Void
	{
		GaiaHQ.instance.removeEventListener(GaiaEvent.BEFORE_GOTO, target);
	}
	public function removeAfterGoto(target:Function):Void
	{
		GaiaHQ.instance.removeEventListener(GaiaEvent.AFTER_GOTO, target);
	}
	
	public function removeBeforeTransitionOut(target:Function):Void
	{
		GaiaHQ.instance.removeListener(GaiaEvent.BEFORE_TRANSITION_OUT, target);
	}
	public function removeAfterTransitionOut(target:Function):Void
	{
		GaiaHQ.instance.removeListener(GaiaEvent.AFTER_TRANSITION_OUT, target);
	}
	
	public function removeBeforePreload(target:Function):Void
	{
		GaiaHQ.instance.removeListener(GaiaEvent.BEFORE_PRELOAD, target);
	}
	public function removeAfterPreload(target:Function):Void
	{
		GaiaHQ.instance.removeListener(GaiaEvent.AFTER_PRELOAD, target);
	}
	
	public function removeBeforeTransitionIn(target:Function):Void
	{
		GaiaHQ.instance.removeListener(GaiaEvent.BEFORE_TRANSITION_IN, target);
	}
	public function removeAfterTransitionIn(target:Function):Void
	{
		GaiaHQ.instance.removeListener(GaiaEvent.AFTER_TRANSITION_IN, target);
	}
	
	public function removeAfterComplete(target:Function):Void
	{
		GaiaHQ.instance.removeListener(GaiaEvent.AFTER_COMPLETE, target);
	}
	
	// Deeplink event
	public function addDeeplinkListener(target:Function):Void
	{
		GaiaSWFAddress.instance.addEventListener(GaiaSWFAddressEvent.DEEPLINK, target);
	}
	public function removeDeeplinkListener(target:Function):Void
	{
		GaiaSWFAddress.instance.removeEventListener(GaiaSWFAddressEvent.DEEPLINK, target);
	}
	
	// Binding Resolution
	public function resolveBinding(value:String):String
	{
		// no expression to resolve
		if (value.indexOf("{") == -1) return value;
		// evaluate expression
		var start:Number = value.indexOf("{");
		var end:Number = value.indexOf("}");
		var expression:String = value.substring(start + 1, end);
		var before:String = value.substring(0, start);
		var after:String = value.substr(end + 1);
		// if expression contains flashvars syntax, look in flashvars
		if (expression.charAt(0) == "@") return resolveBinding(before + _root[expression.substr(1)] + after);
		// if expression does not contain a branch, look in main
		if (expression.indexOf(".") == -1 && expression.indexOf("/") == -1) return resolveBinding(before + GaiaMain.instance[expression] + after);
		// if expression contains a branch, look in that page
		var page:PageAsset = BranchTools.getPage(expression.split(".")[0]);
		if (page != undefined)
		{
			if (page.active && page.percentLoaded == 1) return resolveBinding(before + page.content[expression.split(".")[1]] + after);
		}
		else
		{
			throw new Error("*Invalid Expression* Page '" + expression.split(".")[0] + "' does not exist in site.xml");
		}			
		return value;
	}
}
