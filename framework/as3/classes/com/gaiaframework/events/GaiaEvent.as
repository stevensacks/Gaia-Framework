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
	import flash.events.Event;

	public class GaiaEvent extends Event
	{
		public static const GOTO:String = "goto";
		public static const BEFORE_GOTO:String = "beforeGoto";
		public static const AFTER_GOTO:String = "afterGoto";
		public static const BEFORE_TRANSITION_OUT:String = "beforeTransitionOut";
		public static const AFTER_TRANSITION_OUT:String = "afterTransitionOut";
		public static const BEFORE_PRELOAD:String = "beforePreload";
		public static const AFTER_PRELOAD:String = "afterPreload";
		public static const BEFORE_TRANSITION_IN:String = "beforeTransitionIn";
		public static const AFTER_TRANSITION_IN:String = "afterTransitionIn";
		public static const AFTER_COMPLETE:String = "afterComplete";
		
		public var validBranch:String;
		public var fullBranch:String;
		public var external:Boolean;
		public var src:String;
		public var flow:String;
		public var window:String;
		
		public function GaiaEvent(type:String, bubbles:Boolean, cancelable:Boolean, validBranch:String, fullBranch:String, external:Boolean, src:String, flow:String = null, window:String = "_self")
		{
			super(type, bubbles, cancelable);
			this.validBranch = validBranch;
			this.fullBranch = fullBranch;
			this.external = external;
			this.src = src;
			this.flow = flow;
			this.window = window;
		}
		public override function clone():Event
		{
			return new GaiaEvent(type, bubbles, cancelable, validBranch, fullBranch, external, src, flow, window);
		}
		public override function toString():String
		{
			return formatToString("GaiaEvent", "type", "bubbles", "cancelable", "eventPhase", "validBranch", "fullBranch", "external", "src", "flow", "window");
		}
	}
}