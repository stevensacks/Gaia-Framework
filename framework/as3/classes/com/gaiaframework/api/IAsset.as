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
	import flash.events.IEventDispatcher;

	/**
	 * Dispatched when the asset is finished loading. Used with on-demand assets.
	 * The <code>target</code> or <code>asset</code> property 
	 * @eventType com.gaiaframework.events.AssetEvent.ASSET_COMPLETE
	 */
	[Event(name = "assetComplete", type = "com.gaiaframework.events.AssetEvent")]
	/**
	 * @private
	 */
	[Event(name = "assetProgress", type = "com.gaiaframework.events.AssetEvent")]
	
	/**
	 * This is the interface of the abstract asset class for all concrete asset classes.
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Assets Assets Documentation
	 *  
	 * @author Steven Sacks
	 */
	public interface IAsset extends IEventDispatcher
	{
		/**
		 * Used to load assets on-demand.  Sound and NetStream assets will start playing immediately.  The args are for internal Gaia use only.
		 */
		function load(...args):void;
		/**
		 * Used to manually abort an on-demand asset load.
		 */
		function abort():void;
		/**
		 * Returns the loaded bytes of the file.
		 */
		function getBytesLoaded():int;
		/**
		 * Returns the total bytes of the file.
		 */
		function getBytesTotal():int;
		/**
		 * Returns the bytesLoaded / bytesTotal.
		 */
		function get percentLoaded():Number;
		/**
		 * Returns the ID as set in <code>site.xml</code>. Assets need unique IDs per page and the IDs cannot be a reserved property or function name of <code>MovieClip</code> objects. The ID must be alphanumeric (no hyphens or underscores), and must start with a letter, not a number.
		 */
		function get id():String;
		/**
		 * Returns the source path of the asset.
		 */
		function get src():String;
		/**
		 * @private
		 */
		function set src(value:String):void;
		/**
		 * Specifies the title of the asset.
		 */
		function get title():String;
		/**
		 * @private
		 */
		function set title(value:String):void;
		/**
	     * Specifies a value of <code>true</code> if the asset is set to preload, or <code>false</code> if it is on-demand.
	     */
		function get preloadAsset():Boolean;
		/**
		 * @private
		 */
		function set preloadAsset(value:Boolean):void;
		/**
		 * Specifies whether the asset will cause the asset preloader to appear when loaded on-demand.  <code>true</code> if the asset will show the asset preloader (default), <code>false</code> if not.  In the <code>site.xml</code>, this property is represented with the <code>progress</code> attribute.
		 */
		function get showProgress():Boolean;
		/**
		 * @private
		 */
		function set showProgress(value:Boolean):void;
		/**
		 * Returns the bytes attribute value set in the <code>site.xml</code> for byte-accurate preloading.
		 */
		function get bytes():int;
		/**
		 * Returns the load order and position of the asset relative to other assets of the page. SEOAssets are always 0.
		 */
		function get order():int;
		/**
		 * Returns the raw XML node of the asset
		 */
		function get node():XML;
	}
}