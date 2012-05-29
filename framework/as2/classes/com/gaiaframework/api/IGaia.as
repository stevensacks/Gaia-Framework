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

import com.gaiaframework.assets.MovieClipAsset;
import com.gaiaframework.assets.PageAsset;

interface com.gaiaframework.api.IGaia
{
	function goto(branch:String, flow:String):Void;
	function gotoRoute(route:String, deeplink:String, flow:String):Void;
	function getSiteTree():PageAsset;
	function getMenuArray():Array;
	function getSiteTitle():String;
	function setSiteTitle(value:String):Void;
	function getSitePosition():Object;
	function setDelimiter(value:String):Void;
	function getSiteXML():XML;
	function getPage(branch:String):PageAsset;
	function getDepthContainer(name:String):MovieClip;
	
	function getValidBranch(branch:String):String;
	function getCurrentBranch():String;
	function getPreloader():MovieClipAsset;
	function setPreloader(asset:MovieClipAsset):Void;
	function getAssetPreloader():MovieClipAsset;
	function setAssetPreloader(asset:MovieClipAsset):Void;
	function getDeeplink():String;
	function getDefaultFlow():String;
	function setDefaultFlow(flow:String):Void;
	function addAssets(nodes:Array, page:PageAsset):Void;
	function refreshContextMenu():Void;
	function getWidth():Number;
	function getHeight():Number;
	function setLoadTimeout(value:Number):Void;
	function setPreloaderDelay(value:Number):Void;
	function setGlobalVolume(value:Number, duration:Number, onComplete:Function):Void;
	function addCustomAsset(assetClass:Function, type:String):Void;
	function getBusy():Boolean;
	
	// SWFAddress Proxy
	function back():Void;
	function forward():Void;
	function getTitle():String;
	function setTitle(title:String):Void;
	function href(url:String, target:String):Void;
	function popup(url:String, name:String, options:String, handler:String):Void;
	function getValue():String;
	function setHistory(value:Boolean):Void;
	function getHistory():Boolean;
	function setTracker(value:String):Void;
	function getTracker():String;
	function getBaseURL():String;

	// hijack Events
	function beforeGoto(target:Function, hijack:Boolean, onlyOnce:Boolean):Function;
	function afterGoto(target:Function, hijack:Boolean, onlyOnce:Boolean):Function;		
	
	function beforeTransitionOut(target:Function, hijack:Boolean, onlyOnce:Boolean):Function;
	function afterTransitionOut(target:Function, hijack:Boolean, onlyOnce:Boolean):Function;
	
	function beforePreload(target:Function, hijack:Boolean, onlyOnce:Boolean):Function;
	function afterPreload(target:Function, hijack:Boolean, onlyOnce:Boolean):Function;
	
	function beforeTransitionIn(target:Function, hijack:Boolean, onlyOnce:Boolean):Function;
	function afterTransitionIn(target:Function, hijack:Boolean, onlyOnce:Boolean):Function;
	
	function afterComplete(target:Function, onlyOnce:Boolean):Function;
	
	// Remove hijack Events (just in case you need to manually)
	function removeBeforeGoto(target:Function):Void;
	function removeAfterGoto(target:Function):Void;
	
	function removeBeforeTransitionOut(target:Function):Void;
	function removeAfterTransitionOut(target:Function):Void;
	
	function removeBeforePreload(target:Function):Void;
	function removeAfterPreload(target:Function):Void;
	
	function removeBeforeTransitionIn(target:Function):Void;
	function removeAfterTransitionIn(target:Function):Void;
	
	function removeAfterComplete(target:Function):Void;
	
	// Deeplink event
	function addDeeplinkListener(target:Function):Void;
	function removeDeeplinkListener(target:Function):Void;
}