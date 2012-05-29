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

package com.gaiaframework.api
{
	import flash.display.Sprite;
	import flash.ui.ContextMenu;

	/**
	 * This is the interface of the Gaia API.  The Gaia API simplifies the way you interact with the framework.  Most of the power of Gaia comes from how you structure your site.xml and how you handle its events.
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=API API Documentation
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Events_and_Hijacking Events and Hijacking Documentation
	 *  
	 * @author Steven Sacks
	 */
	public interface IGaia
	{
		/**
		 * goto is the primary method you will be using in Gaia. It requires at least one argument and that is a string of the branch you want to navigate to.  
		 * 
		 * The optional second argument is for overriding the flow for the goto event. Use the flow constants for these: Gaia.NORMAL, Gaia.PRELOAD, and Gaia.REVERSE. Gaia will use that and ignore the page's flow type as well as the site's default flow. <strong>This feature is primarily used for testing during development only.</strong> If you pass a flow, and then use the browser to navigate back and forward, the passed flow will not be used again because SWFAddress is what is calling goto then, not your original goto. For production, you should set the flow on the page either through <code>site.xml</code> or at runtime.
		 * 
		 * @param	branch The branch to navigate to
		 * @param	flow The flow override to use
		 */
		function goto(branch:String, flow:String = null):void;
		/**
		 *  gotoRoute is an alternative to goto().  It allows you to pass a route instead of a full branch.  If you pass an invalid route, Gaia will goto("index").
		 * 
		 * @param	route The branch to navigate to
		 * @param	flow The flow override to use
		 */
		function gotoRoute(route:String, deeplink:String = null, flow:String = null):void;
		/**
		 * Returns the PageAsset instance of the index page. 
		 */
		function getSiteTree():IPageAsset;
		/**
		 * Returns an array of all the pages in the site.xml with menu="true" and that have a title. The pages are returned in order from top to bottom.
		 */
		function getMenuArray():Array;
		/**
		 * Returns the value of the title attribute of the site node with the %PAGE% token still inside it. 
		 */
		function getSiteTitle():String;
		/**
		 * Sets the title of the site. You should include the %PAGE% token if you want it.
		 * @param	value The title of the site.
		 */
		function setSiteTitle(value:String):void;
		/**
		 * Returns the current Site View x,y position as an object with properties x and y.  This is useful when using site centering code.
		 */
		function getSitePosition():Object;
		/**
		 * Sets the delimiter for the site if you setSiteTitle with a different delimiter. You need to call refreshContextMenu() to have this change reflected in the ContextMenu.
		 * @param	value The delimiter value
		 */
		function setDelimiter(value:String):void;
		/**
		 * Returns the raw site.xml 
		 */
		function getSiteXML():XML;
		/**
		 * Returns the instance of the PageAsset for that page. You pass it a branch and it returns the PageAsset of the final page of that branch. If the final leaf of the branch you passed is not a valid page id, it will return null.
		 * <p>PageAsset has a property called children, which is an object which contains properties that match the ids of the pages of those children, and the values of those properties are the PageAssets themselves. PageAssets are aware of who their parent is, and pages also store their branch as a public property.</p>
		 * <p>If you need to target the timeline of a page for custom properties, functions, or MovieClips, use the "content" property of the PageAsset.</p>
		 * <p><code>Gaia.api.getPage("index/nav/home").content.myProp = value;<br/>Gaia.api.getPage("index/nav/home").content.myFunc();<br/>Gaia.api.getPage("index/nav/home").content.MC_Movieclip.x = 10;</code></p>
		 * <p>More information about page properties can be found in the PageAsset, Pages and Site XML sections of the documentation.</p>
		 * 
		 * @param	branch The branch
		 */
		function getPage(branch:String):IPageAsset;
		/**
		 * Returns the Sprite or MovieClip depth container. Pass one of the depth constants when using this method. 
		 * <p><code>var top:Sprite = getDepthContainer(Gaia.TOP);</code></p>
		 * 
		 * @param	name A depth constant
		 */
		function getDepthContainer(name:String):Sprite;
		/**
		 * Returns a valid branch for whatever branch you pass it.  A valid branch is one that can be resolved in the <code>site.xml</code>.
		 * 
		 * @param	branch The branch
		 */
		function getValidBranch(branch:String):String;
		/**
		 * Returns the current valid branch. 
		 */
		function getCurrentBranch():String;
		/**
		 * Returns the preloader MovieClipAsset. You can use this to call custom methods inside your preloader swf (via the .content property), reposition the preloader clip, etc. 
		 * 
		 * @see		IMovieClip
		 */
		function getPreloader():IMovieClip;
		/**
		 * Override the preloader MovieClipAsset with a reference to an already loaded MovieClipAsset. If you want to revert to the default preloader, call this method without passing anything. 
		 * @param	asset A MovieClipAsset whose content implements IPreloader.  Pass nothing or null to revert to the original preloader.
		 */
		function setPreloader(asset:IMovieClip = null):void;
		/**
		 * Returns the asset preloader MovieClipAsset. You can use this to call custom methods inside your asset preloader swf (via the .content property), reposition the preloader clip, etc. 
		 * 
		 * @see		IMovieClip
		 */
		function getAssetPreloader():IMovieClip;
		/**
		 * This allows you to override the AssetPreloader MovieClipAsset to use the MovieClipAsset you pass (by default it uses the current site preloader). If you want to revert to the site preloader, call this method with no parameters.
		 * @param	asset A MovieClipAsset whose content implements IPreloader.  Pass null to revert to the site preloader.
		 */
		function setAssetPreloader(asset:IMovieClip = null):void;
		/**
		 * Returns the deep link from the GaiaSWFAddress class that goes beyond the realm of the site.xml. When you have a page that needs to know the deeplink when it first opens, use getDeeplink() since it won't be open when the event fires. 
		 */
		function getDeeplink():String;
		/**
		 * Returns the current default flow for any pages that do not have a flow defined (returns "normal", "preload", "reverse" or "cross"). 
		 */
		function getDefaultFlow():String;
		/**
		 * Allows you to set the default flow for any pages that do not have a flow defined. Use one of the flow constants: Gaia.NORMAL, Gaia.PRELOAD, Gaia.REVERSE or Gaia.CROSS. 
		 * @param	flow One of the flow constants.
		 */
		function setDefaultFlow(flow:String):void;
		/**
		 * Returns the ContextMenu attached to GaiaMain by Gaia, making it easier to modify the custom items in the ContextMenu, such as adding custom menu items that are not Gaia pages. 
		 */
		function getContextMenu():ContextMenu;
		/**
		 * If you change the titles of pages or the site title, call this method to refresh the context menu to show the new values.
		 */
		function refreshContextMenu():void;
		/**
		 * This method is used to add externalized dynamic assets to a page at runtime.
		 * 
		 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Assets#Dynamic_Externalized_Assets Dynamic Externalized Assets Documentation
		 * 
		 * @param	nodes An XMLList of nodes with id and src attributes.
		 * @param	page The PageAsset to add the assets to.
		 */
		function addAssets(nodes:XMLList, page:IPageAsset):void;
		/**
		 * Returns the fixed width of the Gaia site as defined in Main.  Useful if the stage is set to 100% width.
		 */
		function getWidth():int;
		/**
		 * Returns the fixed height of the Gaia site as defined in Main.  Useful if the stage is set to 100% height.
		 */
		function getHeight():int;
		/**
		 * When a branch is loading, each file must show progress within a certain amount of time before Gaia will attempt to reload the file. 
		 * This method allows you to adjust how long Gaia waits until a file shows progress.
		 * 
		 * Default: 10000ms
		 * Minimum: 3000ms
		 * 
		 * @param	value The time in milliseconds to wait for a file in a branch load to show progress
		 */
		function setLoadTimeout(value:int):void;
		/**
		 * @param	value The time in milliseconds to delay the preloader transitionIn call (so it doesn't show up for cached content).  The default value is 150.
		 */
		function setPreloaderDelay(value:int):void;
		/**
		 * Sets the global volume of the entire site. 
		 * Passing a duration will fade the global volume.
		 * Passing an onComplete function will call it when the fade is complete.
		 * 
		 * @param value 0-1 The value you want to set the global volume to
		 * @param duration The duration in seconds you want to fade the global volume to value
		 * @param onComplete The function you want to call when the global volume fade is complete
		 */
		function setGlobalVolume(value:Number, duration:Number = 0, onComplete:Function = null):void;
		/**
		 * Returns the global volume of the entire site.
		 */
		function getGlobalVolume():Number;
		/**
		 * @param	className The class name assigned to the font
		 * @return  Returns the runtime name of the font for use with TextFormat
		 */
		function getFontName(className:String):String;
		/**
		 * @return An Array of the class names of all available fonts in the swf.  This array only contains the names of fonts that successfully registered. These names can be passed to getFontName().
		 */
		function getAvailableFonts():Array;
		/**
		 * @param	assetClass The Class that refers to the custom asset class - Class MUST extend AbstractAsset
		 * @param	type The type that the custom asset class is associated with in the asset node type attribute.
		 */
		function addCustomAsset(assetClass:Class, type:String):void;
		
		function getBusy():Boolean;
		
		// SWFAddress Proxy
		/**
		 * Loads the previous URL in the history list. 
		 */
		function back():void;
		/**
		 * Loads the next URL in the history list. 
		 */
		function forward():void;
		/**
		 * Returns the current title of the browser window. 
		 */
		function getTitle():String;
		/**
		 * Allows you to set the title of the browser. The string you pass will be the entire title, so if you want to append something to or alter the current title, you should getTitle() or getSiteTitle(), modify that and pass it to setTitle(). 
		 * @param	title The title of the browser.
		 */
		function setTitle(title:String):void;
		/**
		 * This method is a substitute for getURL. 
		 * @param	url The url to navigate to.
		 * @param	target The target window ("_self", "_blank", etc.).
		 */
		function href(url:String, target:String = null):void;
		/**
		 * Opens a browser popup window. 
		 * @param	url The url of the popup window.
		 * @param	name The name of the popup window.
		 * @param	options The options of the popup window.
		 * @param	handler The handler of the popup window.
		 */
		function popup(url:String, name:String, options:String, handler:String = null):void;
		/**
		 * Calls SWFAddress.getValue() via a proxy so it always works even at site launch
		 * @return The string value in the address bar after the #
		 */
		function getValue():String;
		/**
		 * Turns history tracking in the browser on and off by passing true or false. It is turned on by default, unless you set history="false" in the site.xml site node.
		 * @param	value A Boolean of "true" to turn history on, and "false" to turn it off.
		 */
		function setHistory(value:Boolean):void;
		/**
		 * @private
		 */
		function getHistory():Boolean;
		/**
		 * Sets a function for page view tracking. The default value is 'urchinTracker'. 
		 * @param	value The tracker function name.
		 */
		function setTracker(value:String):void;
		/**
		 * @private
		 */
		function getTracker():String;
		/**
		 * Returns the base URL of the website. This means everything before the # hash symbol that SWFAddress uses for deeplinking. 
		 */
		function getBaseURL():String;
		/**
		 * The beforeGoto event fires before the goto event gets dispatched to the framework. beforeGoto occurs whenever a goto is called, regardless of whether the branch is external or the branch is the current branch (which Gaia ignores - check the How Gaia Works section of the documentation for more information). 
		 * @param	target A function that is the listener.
		 * @param	hijack Make the framework wait for you to tell it to continue by calling the function that is returned with this function. 
		 * @param	onlyOnce Only listen for this event once and then automatically remove the target as a listener. 
		 * @return  If hijack is <code>true</code>, returns the function that will release Gaia, otherwise returns null.
		 */
		function beforeGoto(target:Function, hijack:Boolean = false, onlyOnce:Boolean = false):Function;
		/**
		 * The afterGoto event fires after the goto event succeeds and before the flow begins. afterGoto and the events that follow occur only when the goto is an internal page that is different than the current page.  
		 * @param	target A function that is the listener.
		 * @param	hijack Make the framework wait for you to tell it to continue by calling the function that is returned with this function. 
		 * @param	onlyOnce Only listen for this event once and then automatically remove the target as a listener. 
		 * @return  If hijack is <code>true</code>, returns the function that will release Gaia, otherwise returns null.
		 */
		function afterGoto(target:Function, hijack:Boolean = false, onlyOnce:Boolean = false):Function;		
		/**
		 * The beforeTransitionOut event fires before the transition out phase begins. 
		 * @param	target A function that is the listener.
		 * @param	hijack Make the framework wait for you to tell it to continue by calling the function that is returned with this function. 
		 * @param	onlyOnce Only listen for this event once and then automatically remove the target as a listener. 
		 * @return  If hijack is <code>true</code>, returns the function that will release Gaia, otherwise returns null.
		 */
		function beforeTransitionOut(target:Function, hijack:Boolean = false, onlyOnce:Boolean = false):Function;
		/**
		 * The afterTransitionOut event fires after the transition out phase is finished. 
		 * @param	target A function that is the listener.
		 * @param	hijack Make the framework wait for you to tell it to continue by calling the function that is returned with this function. 
		 * @param	onlyOnce Only listen for this event once and then automatically remove the target as a listener. 
		 * @return  If hijack is <code>true</code>, returns the function that will release Gaia, otherwise returns null.
		 */
		function afterTransitionOut(target:Function, hijack:Boolean = false, onlyOnce:Boolean = false):Function;
		/**
		 * The beforePreload event fires before the preloading of the new branch starts.  
		 * @param	target A function that is the listener.
		 * @param	hijack Make the framework wait for you to tell it to continue by calling the function that is returned with this function. 
		 * @param	onlyOnce Only listen for this event once and then automatically remove the target as a listener. 
		 * @return  If hijack is <code>true</code>, returns the function that will release Gaia, otherwise returns null.
		 */
		function beforePreload(target:Function, hijack:Boolean = false, onlyOnce:Boolean = false):Function;
		/**
		 * The afterPreload event fires after the preloading of the new branch is finished.
		 * @param	target A function that is the listener.
		 * @param	hijack Make the framework wait for you to tell it to continue by calling the function that is returned with this function. 
		 * @param	onlyOnce Only listen for this event once and then automatically remove the target as a listener. 
		 * @return  If hijack is <code>true</code>, returns the function that will release Gaia, otherwise returns null.
		 */
		function afterPreload(target:Function, hijack:Boolean = false, onlyOnce:Boolean = false):Function;
		/**
		 * The beforeTransitionIn event fires before the transition in phase begins. 
		 * @param	target A function that is the listener.
		 * @param	hijack Make the framework wait for you to tell it to continue by calling the function that is returned with this function. 
		 * @param	onlyOnce Only listen for this event once and then automatically remove the target as a listener. 
		 * @return  If hijack is <code>true</code>, returns the function that will release Gaia, otherwise returns null.
		 */
		function beforeTransitionIn(target:Function, hijack:Boolean = false, onlyOnce:Boolean = false):Function;
		/**
		 * The afterTransitionIn event fires after the transition in phase is finished. 
		 * @param	target A function that is the listener.
		 * @param	hijack Make the framework wait for you to tell it to continue by calling the function that is returned with this function. 
		 * @param	onlyOnce Only listen for this event once and then automatically remove the target as a listener. 
		 * @return  If hijack is <code>true</code>, returns the function that will release Gaia, otherwise returns null.
		 */
		function afterTransitionIn(target:Function, hijack:Boolean = false, onlyOnce:Boolean = false):Function;
		/**
		 * The afterComplete event fires after the flow is complete. This event cannot be hijacked as it's forced to be false by the API. This is because the afterComplete event fires at the end of the flow so hijacking would be pointless. 
		 * @param	target A function that is the listener.
		 * @param	onlyOnce Only listen for this event once and then automatically remove the target as a listener. 
		 */
		function afterComplete(target:Function, onlyOnce:Boolean = false):Function;
		/**
		 * Removes the beforeGoto event listener
		 * @param	target A function that is the listener.
		 */
		function removeBeforeGoto(target:Function):void;
		/**
		 * Removes the afterGoto event listener
		 * @param	target A function that is the listener.
		 */
		function removeAfterGoto(target:Function):void;
		/**
		 * Removes the beforeTransitionOut event listener
		 * @param	target A function that is the listener.
		 */
		function removeBeforeTransitionOut(target:Function):void;
		/**
		 * Removes the afterTransitionOut event listener
		 * @param	target A function that is the listener.
		 */
		function removeAfterTransitionOut(target:Function):void;
		/**
		 * Removes the beforePreload event listener
		 * @param	target A function that is the listener.
		 */
		function removeBeforePreload(target:Function):void;
		/**
		 * Removes the afterPreload event listener
		 * @param	target A function that is the listener.
		 */
		function removeAfterPreload(target:Function):void;
		/**
		 * Removes the beforeTransitionIn event listener
		 * @param	target A function that is the listener.
		 */
		function removeBeforeTransitionIn(target:Function):void;
		/**
		 * Removes the afterTransitionIn event listener
		 * @param	target A function that is the listener.
		 */
		function removeAfterTransitionIn(target:Function):void;
		/**
		 * Removes the afterComplete event listener
		 * @param	target A function that is the listener.
		 */
		function removeAfterComplete(target:Function):void;
		/**
		 * The deeplink event occurs whenever the SWFAddress class updates, either from the browser or from a goto event. The event passes any deep link beyond the scope of the current branch in the event object as a property called "deeplink".<p>For instance, if you have a page branch of "index/home/photos" and you want to be able to deep link to and bookmark a specific photo, such as "index/home/photos/4", the deeplink event will pass you "/4". In this example, the user could type different numbers into the address bar, so your code would need to handle deeplink values that are invalid.</p><p>Most of the time, you will never need to use the addDeeplinkListener method, as Pages are automatically set up to receive onDeeplink events.</p>
		 * @param	target A function that is the listener.
		 */
		function addDeeplinkListener(target:Function):void;
		/**
		 * Removes a deeplink listener.
		 * @param	target A function that is the listener.
		 */
		function removeDeeplinkListener(target:Function):void;
	}
}