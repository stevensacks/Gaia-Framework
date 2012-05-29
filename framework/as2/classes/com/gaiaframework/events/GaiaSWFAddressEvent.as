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

class com.gaiaframework.events.GaiaSWFAddressEvent extends Event
{
	public static var DEEPLINK:String = "deeplink";
	public static var GOTO:String = "goto";
	
	public var deeplink:String;
	public var branch:String;
	
	public function GaiaSWFAddressEvent(type:String, target:Object, deeplink:String, branch:String)
	{
		super(type, target);
		this.deeplink = deeplink;
		this.branch = branch;
	}
	public function clone():Event
	{
		return new GaiaSWFAddressEvent(type, target, deeplink, branch);
	}
	public function toString():String
	{
		return formatToString("GaiaSWFAddressEvent", "type", "deeplink", "branch");
	}
}