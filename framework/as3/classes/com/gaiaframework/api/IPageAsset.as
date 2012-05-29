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
	/**
	 * This is the interface for the <code>PageAsset</code>.  PageAsset extends MovieClipAsset.
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Pages Pages Documentation
	 * 
	 * @author Steven Sacks
	 */
	public interface IPageAsset extends IMovieClip
	{
		/**
		 * A hash of the Page's child Pages (stored by their id).
		 */
		function get children():Object;
		/**
		 * A hash of the Page's assets (stored by their id).
		 */
		function get assets():Object;
		/**
		 * @private
		 */
		function set assets(value:Object):void;
		/**
		 * Returns an array of the assets in the order they are listed in the site.xml. This getter creates the array on the fly every time in order to support dynamically added assets, so make sure you store a reference to it when iterating through it, otherwise you will be recreating the Array every iteration - not good!
		 * 
		 * <p><code>var assetArray:Array = page.assetArray;<br/>var len:int = assetArray.length;<br/>for (var i:int = 0; i &lt; len; i++)<br/>{<br/>&nbsp;&nbsp;&nbsp;&nbsp;trace(assetArray[i]);<br/>}</code></p>
		 */
		function get assetArray():Array;
		/**
		 * A hash of the Page's copy (stored by their id).
		 * 
		 * @see http://www.gaiaflashframework.com/wiki/index.php?title=SEO Gaia SEO Documentation
		 */
		function get copy():Object;
		/**
		 * Returns true if the page is external, and false if the page is internal.
		 */
		function get external():Boolean;
		/**
		 * Returns a Boolean whether the page will appear in the context menu.  true if the page appears in the context menu, and false if not.
		 * 
		 */
		function get menu():Boolean;
		/**
		 * @private
		 */
		function set menu(value:Boolean):void;
		/**
		 * Returns the custom flow the page uses.  This is null by default.
		 * 
		 */
		function get flow():String;
		/**
		 * @private
		 */
		function set flow(value:String):void;
		/**
		 * This is set to the first child of the Page from the site.xml structure by default. You can set this during runtime. One good use for this is if an intro page is the first child of a Page and you want to not go back to the intro from then on if you navigate to the intro page's parent page, you can set the parent's defaultChild to another of its children. This is also helpful during development if you want Gaia to go straight to a specific child.
		 * 
		 */
		function get defaultChild():String;
		/**
		 * @private
		 */
		function set defaultChild(value:String):void;
		/**
		 * Returns the route of the page if set in the site.xml. If you don't want the page's title to be its "pretty URL", or if your page title contains a special character which cannot be displayed in the address bar (such as non-Latin characters), set the value of this attribute for the page's url in the address bar. Routes must be unique and can only be applied to terminal pages (pages that have no children).
		 * 
		 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Site_XML#route Route Documentation
		 */
		function get route():String;
		/**
		 * Returns the page's branch, starting from the index page.
		 */
		function get branch():String;
		/**
		 * Use this attribute to set the folder paths for all assets of that page. All assets inside this page will load from this folder path so you can organize your assets without bloating your site.xml. Make sure your assetPath ends in a forward slash! You can use ../ in the asset node src attribute to go up to parent folders. This trumps the site node assetPath for the page that it is set on. 
		 * 
		 */
		function get assetPath():String;
		/**
		 * @private
		 */
		function set assetPath(value:String):void;
		/**
		 * If the page is external (src attribute is not a swf or a javascript method), you can define the target window it will open up in. The default is "_self". If you want it to open in a new window, use "_blank". 
		 */
		function get window():String;
		/**
		 * @private
		 */
		function set window(value:String):void;
		/**
		 * If you want to override Gaia's default behavior of loading the default child of a page branch, set landing="true" and Gaia will stop on this page if you tell it to goto this page. 
		 */
		function get landing():Boolean;
		/**
		 * @private
		 */
		function set landing(value:Boolean):void;
		/**
		 * [read-only] This method returns the page's parent PageAsset. 
		 */
		function getParent():IPageAsset;
		/**
		 * @private
		 */
		function setParent(page:IPageAsset):void;
		/**
		 * @private 
		 * This method is called by Gaia and is not meant to be called by developers.
		 */
		function transitionIn():void;
		/**
		 * @private 
		 * This method is called by Gaia and is not meant to be called by developers.
		 */
		function transitionOut():void;
	}
}