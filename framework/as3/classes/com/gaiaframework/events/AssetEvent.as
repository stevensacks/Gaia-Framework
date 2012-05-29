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

package com.gaiaframework.events
{
	import com.gaiaframework.api.IAsset;

	import flash.events.Event;

	/**
	 * The AssetEvent is used by the IPreloader and is also used to listen for when on-demand assets are finished loading.
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Events_Package#AssetEvent AssetEvent Documentation
	 *  
	 * @author Steven Sacks
	 */
	public class AssetEvent extends Event
	{
		/**
		 * This event type is dispatched when loading on-demand assets and you need to know when they're finished loading.
		 */	
		public static const ASSET_COMPLETE:String = "assetComplete";
		/**
		 * @private
		 */
		public static const ASSET_PROGRESS:String = "assetProgress";
		/**
		 * @private
		 */
		public static const ASSET_ERROR:String = "assetError";
		
		/**
		 * This is a reference to the asset (pages are a type of asset) that is currently loading. In the default template, this information is used by the preloader to show the current asset being loaded and its individual progress. 
		 */
		public var asset:IAsset;
		/**
		 * If bytes is true, this is the number of bytes loaded so far. If not, this is the count of the current page or asset in the branch that is loading. 
		 */
		public var loaded:int;
		/**
		 * If bytes is true, this is the total number of bytes of all files loading. Otherwise, this is the total number of pages and/or assets in the branch that are loading. 
		 */
		public var total:int;
		/**
		 * This is the overall percentage of the load for the entire branch, which is a floating point number from 0 to 1. 
		 */
		public var perc:Number;
		/**
		 * If the total bytes of all files are set in the xml, this flag lets you know the loaded and total properties are bytes. 
		 */
		public var bytes:Boolean;
		
		/**
		 * @private
		 */
		public function AssetEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, asset:IAsset = null, loaded:int = 0, total:int = 0, perc:Number = 0, bytes:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.asset = asset;
			this.loaded = loaded;
			this.total = total;
			this.perc = perc;
			this.bytes = bytes;
		}
		/**
		 * @private
		 */
		public override function clone():Event
		{
			return new AssetEvent(type, bubbles, cancelable, asset, loaded, total, perc, bytes);
		}
		/**
		 * @private
		 */
		public override function toString():String
		{
			return formatToString("AssetEvent", "type", "bubbles", "cancelable", "eventPhase", "asset", "loaded", "total", "perc", "bytes");
		}
	}
}