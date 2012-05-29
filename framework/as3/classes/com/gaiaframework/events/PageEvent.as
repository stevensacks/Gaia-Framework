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

	public class PageEvent extends Event
	{
		public static const TRANSITION_OUT:String = "transitionOut";
		public static const TRANSITION_IN:String = "transitionIn";
		public static const TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
		public static const TRANSITION_IN_COMPLETE:String = "transitionInComplete";
		
		public function PageEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		public override function clone():Event
		{
			return new PageEvent(type, bubbles, cancelable);
		}
		public override function toString():String
		{
			return formatToString("PageEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}