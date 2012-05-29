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

import com.gaiaframework.events.Event;

class com.gaiaframework.events.NetStreamAssetEvent extends Event
{
	public static var METADATA:String = "metaData";
	public static var CUEPOINT:String = "cuePoint";
	public static var STATUS:String = "status";
	
	public var info:Object;
	
	public function NetStreamAssetEvent(type:String, target:Object, info:Object)
	{
		super(type, target);
		this.info = info;
	}
	public function clone():Event
	{
		return new NetStreamAssetEvent(type, target, info);
	}
	public function toString():String
	{
		return formatToString("NetStreamAssetEvent", "type", "info");
	}
}