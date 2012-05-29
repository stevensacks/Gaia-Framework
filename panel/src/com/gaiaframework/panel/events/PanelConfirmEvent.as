/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2012
* Author: Steven Sacks
*
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.events
{
	import flash.events.Event;

	public class PanelConfirmEvent extends Event
	{
		public static const CONFIRM:String = "confirm";
		
		public var result:Boolean;
		
		public function PanelConfirmEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, result:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.result = result;
		}
		public override function clone():Event
		{
			return new PanelConfirmEvent(type, bubbles, cancelable, result);
		}
		public override function toString():String
		{
			return formatToString("PanelConfirmEvent", "type", "bubbles", "cancelable", "eventPhase", "result");
		}
	}
}