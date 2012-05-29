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

class com.gaiaframework.events.GaiaEvent extends Event
{
	public static var GOTO:String = "goto";
	public static var BEFORE_GOTO:String = "beforeGoto";
	public static var AFTER_GOTO:String = "afterGoto";
	public static var BEFORE_TRANSITION_OUT:String = "beforeTransitionOut";
	public static var AFTER_TRANSITION_OUT:String = "afterTransitionOut";
	public static var BEFORE_PRELOAD:String = "beforePreload";
	public static var AFTER_PRELOAD:String = "afterPreload";
	public static var BEFORE_TRANSITION_IN:String = "beforeTransitionIn";
	public static var AFTER_TRANSITION_IN:String = "afterTransitionIn";
	public static var AFTER_COMPLETE:String = "afterComplete";
	
	public var validBranch:String;
	public var fullBranch:String;
	public var external:Boolean;
	public var src:String;
	public var flow:String;
	public var window:String;
	
	public function GaiaEvent(type:String, target:Object, validBranch:String, fullBranch:String, external:Boolean, src:String, flow:String, window:String)
	{
		super(type, target);
		this.validBranch = validBranch;
		this.fullBranch = fullBranch;
		this.external = external;
		this.src = src;
		this.flow = flow;
		this.window = window;
	}
	public function clone():Event
	{
		return new GaiaEvent(type, target, validBranch, fullBranch, external, src, flow, window);
	}
	public function toString():String
	{
		return formatToString("GaiaEvent", "type", "validBranch", "fullBranch", "external", "src", "flow", "window");
	}
}