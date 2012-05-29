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

import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.events.Event;

class com.gaiaframework.events.BranchLoaderEvent extends Event
{
	public static var LOAD_PAGE:String = "loadPage";
	public static var LOAD_ASSET:String = "loadAsset";
	public static var START:String = "start";
	public static var COMPLETE:String = "complete";
	
	public var asset:AbstractAsset;
	
	public function BranchLoaderEvent(type:String, target:Object, asset:AbstractAsset)
	{
		super(type, target);
		this.asset = asset;
	}
	public function clone():Event
	{
		return new BranchLoaderEvent(type, target, asset);
	}
	public function toString():String
	{
		return formatToString("BranchLoaderEvent", "type", "asset");
	}
}