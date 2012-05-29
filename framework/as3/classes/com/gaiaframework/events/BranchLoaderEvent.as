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
	import com.gaiaframework.assets.AbstractAsset;

	import flash.events.Event;

	public class BranchLoaderEvent extends Event
	{
		public static const LOAD_PAGE:String = "loadPage";
		public static const LOAD_ASSET:String = "loadAsset";
		public static const START:String = "start";
		public static const COMPLETE:String = "complete";
		
		public var asset:AbstractAsset;
		
		public function BranchLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, asset:AbstractAsset = null)
		{
			super(type, bubbles, cancelable);
			this.asset = asset;
		}
		public override function clone():Event
		{
			return new BranchLoaderEvent(type, bubbles, cancelable, asset);
		}
		public override function toString():String
		{
			return formatToString("BranchLoaderEvent", "type", "bubbles", "cancelable", "eventPhase", "asset");
		}
	}
}